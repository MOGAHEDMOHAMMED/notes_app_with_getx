// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/controllers/language_controller.dart';
import 'package:notes_app_with_getx/core/app_routes.dart';
import 'package:notes_app_with_getx/views/screens/auth/create_user_screen.dart';
import 'package:notes_app_with_getx/views/widget/build_text_field.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import 'package:notes_app_with_getx/controllers/ui_state_controller.dart';
import '../../../controllers/auth_controller.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final theme = Theme.of(context);
    final languageController = Get.find<LanguageController>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'loginTitle'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_note_outlined,
                        size: 80,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  //Email Text Field:
                  BuildTextField(
                    controller: emailController,
                    label: 'emailLabel'.tr,
                    icon: Icons.email,
                    theme: theme,
                  ),
                  const SizedBox(height: 20),

                  //Password Text Field:
                  Obx(
                    () => BuildTextField(
                      controller: passwordController,
                      label: 'passwordLabel'.tr,
                      icon: Get.find<UIStateController>().isObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      theme: theme,
                      isObscured: Get.find<UIStateController>().isObscured,
                      isPassword: true,
                      onIconPressed: () =>
                          Get.find<UIStateController>().toggleVisibility(),
                    ),
                  ),
                  const SizedBox(height: 40),

                  //LogIn Button With email and pass:
                  Obx(
                    () => authController.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () async {
                              String? error = await authController
                                  .signInWithEmail(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                              if (!context.mounted) return;
                              if (error != null) {
                                Get.dialog(
                                  AlertDialog(
                                    backgroundColor: Colors.red.shade200,
                                    title: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    content: Text(
                                      error,
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Text('okButton'.tr),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                              Get.offAllNamed(AppRoutes.activeNotesScreen);
                            },
                            child: Text(
                              'loginButton'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  //Don't have an account? Sign Up:
                  TextButton(
                    onPressed: () {
                      Get.to(() => CreateUserScreen());
                    },
                    child: Text(
                      'noAccount'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const Divider(height: 40),

                  //Sing in With Google:
                  OutlinedButton.icon(
                    onPressed: () async {
                      var result = await authController.signInWithGoogle();
                      if (result != null) {
                        HelperMethods.showErrorDialog(result);
                        return;
                      }
                      Get.offAllNamed(AppRoutes.activeNotesScreen);
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                    label: Text('googleButton'.tr),
                  ),
                  const SizedBox(height: 20),

                  //change Language Button:
                  Container(
                    alignment: Alignment.bottomRight,
                    width: 170,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        languageController.changeLanguage(
                          languageController.savedLocale().languageCode == "ar"
                              ? "en"
                              : "ar",
                        );
                      },
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'language'.tr,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Icon(Icons.language_sharp),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
