import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:notes_app_with_getx/controllers/auth_provider.dart';
import 'package:notes_app_with_getx/views/screens/active_notes_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return authController.isLoggedIn ? ActiveNoteScreen() : UserLoginScreen();
  }
}
