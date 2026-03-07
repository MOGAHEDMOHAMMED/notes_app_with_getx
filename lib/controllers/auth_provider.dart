// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import 'package:notes_app_with_getx/views/screens/active_notes_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/login_screen.dart';
import '../core/services/auth_service.dart';
import '../core/services/user_cache_service.dart';

class AuthProvider2 extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserCacheService _userCache = UserCacheService();
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  User? get user => _authService.currentUser;
  AuthProvider2() {
    loadLoginState();
  }
  void loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLogin') ?? false;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _setLogin(bool value) async {
    _isLoggedIn = value;
    notifyListeners(); // Notify UI immediately so AuthWrapper rebuilds
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', value);
  }

  Future<String?> signInWithGoogle() async {
    try {
      _setLoading(true);
      final user = await _authService.signInWithGoogle();

      if (user == null) {
        _setLoading(false);
        _setLogin(false);
        return "تم إلغاء تسجيل الدخول";
      }

      _setLoading(false);
      _setLogin(true);
      return null;
    } catch (e) {
      _setLoading(false);
      _setLogin(false);
      return "حدث خطأ غير متوقع: $e";
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      _setLoading(true);
      final user = await _authService.signInWithEmail(email, password);
      if (user != null) {
        await _userCache.saveUserData(
          user.displayName ?? "مستخدم",
          user.email ?? email,
        );
      }

      _setLoading(false);
      await _setLogin(true);
      return null;
    } catch (e) {
      _setLoading(false);
      await _setLogin(false);
      return "حدث خطأ: تأكد من صحة البريد الإلكتروني وكلمة المرور";
    }
  }

  Future<String?> signUp(String email, String password, String name) async {
    try {
      _setLoading(true);
      await _authService.signUpWithEmail(email, password, name);
      await _userCache.saveUserData(name, email);

      _setLoading(false);
      _setLogin(true);
      return null;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      if (e.code == 'weak-password') {
        _setLogin(false);
        return 'كلمة المرور ضعيفة';
      }
      if (e.code == 'email-already-in-use') {
        _setLogin(false);
        return 'البريد الإلكتروني مسجل مسبقاً';
      }
      _setLogin(false);
      return 'حدث خطأ: ${e.message}';
    } catch (e) {
      _setLoading(false);
      _setLogin(false);
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await _setLogin(false);
  }
}

class AuthController extends GetxController {
  late Rx<User?> _currentUser;
  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';
  final storage = GetStorage();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    _currentUser = _auth.currentUser.obs;
    _currentUser.bindStream(_auth.authStateChanges());

    ever(_currentUser, _routeToHomeOrLogin);
  }

  Future<String?> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading.value = false;
        return "تم إلعاء عملية تسجيل الدخول";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
      }

      _isLoading.value = false;
      return null;
    } catch (e) {
      _isLoading.value = false;
      return "حدث خطأ أثناء تسجيل الدخول عبر Google";
    }
  }

  Future<String?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      _isLoading.value = true;
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await _saveUserToFirestore(credential.user!);
      }
      _isLoading.value = false;
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading.value = false;
      if (e.code == 'weak-password') return 'كلمة المرور ضعيفة';
      if (e.code == 'email-already-in-use') {
        return 'البريد الإلكتروني مسجل مسبقاً';
      }
      return 'حدث خطأ: ${e.message}';
    } catch (e) {
      _isLoading.value = false;
      return 'حدث خطأ غير متوقع';
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      _isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _isLoading.value = false;
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading.value = false;
      e;
      return "حدث خطأ: تأكد من صحة البريد الإلكتروني وكلمة المرور";
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  void _routeToHomeOrLogin(User? user) {
    if (user == null) {
      clearUserData();
      Get.offAll(() => UserLoginScreen());
    } else {
      saveUserData(user.displayName ?? 'مستخدم', user.email ?? '');
      Get.offAll(() => ActiveNoteScreen());
    }
  }

  Future<void> _saveUserToFirestore(User user) async {
    await _db.collection('users').doc(user.uid).set({
      'username': user.displayName ?? 'مستخدم',
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'lastLogin': DateTime.now(),
      'uid': user.uid,
    }, SetOptions(merge: true));
  }

  void saveUserData(String username, String email) {
    storage.write(_keyUsername, username);
    storage.write(_keyEmail, email);
  }

  Map<String, dynamic> getUserData() {
    return {
      'name': storage.read(_keyUsername) ?? 'مستخدم',
      'email': storage.read(_keyEmail) ?? '',
    };
  }

  void clearUserData() {
    storage.remove(_keyUsername);
    storage.remove(_keyEmail);
  }
}
