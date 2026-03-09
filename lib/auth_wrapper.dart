import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/auth_controller.dart';
import 'package:notes_app_with_getx/views/screens/active_notes_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Obx(
      () => authController.isLoggedIn ? ActiveNoteScreen() : UserLoginScreen(),
    );
  }
}
