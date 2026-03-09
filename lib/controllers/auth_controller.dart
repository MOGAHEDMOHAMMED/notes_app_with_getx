// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notes_app_with_getx/controllers/notes_controller.dart';

class AuthController extends GetxController {
  late Rx<User?> _currentUser = _auth.currentUser.obs;
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
    _currentUser.value = _auth.currentUser;
    _currentUser.bindStream(_auth.authStateChanges());

    ever(_currentUser, _listenToUser);
  }

  Future<String?> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading.value = false;
        _currentUser.value=null;
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
        await _saveUserToFirestore(credential.user!, name: name);
      }
      _isLoading.value = false;
      _currentUser.value = credential.user;

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
    _currentUser.value = null;
  }

  Future<void> _listenToUser(User? user) async {
    if (user == null) {
      clearUserData();
      _currentUser.value=null;
    } else {
      saveUserData(user.displayName ?? 'مستخدم', user.email ?? '');
     
    }
  }

  Future<void> _saveUserToFirestore(User user, {String? name}) async {
    await _db.collection('users').doc(user.uid).set({
      'username': name,
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
