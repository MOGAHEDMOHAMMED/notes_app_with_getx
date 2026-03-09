// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notes_app_with_getx/controllers/ui_state_controller.dart';
import 'package:notes_app_with_getx/core/app_routes.dart';
import 'package:notes_app_with_getx/views/widget/build_text_field.dart';
import 'package:notes_app_with_getx/views/widget/helper_methods.dart';
import '../../../controllers/auth_controller.dart' show AuthController;
import '../../../controllers/language_controller.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final theme = Theme.of(context);
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'createAcountTitle'.tr,
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
                        Icons.person_add_alt_1_rounded,
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
                  const SizedBox(height: 20),
                  BuildTextField(
                    controller: fullNameController,
                    label: 'fullName'.tr,
                    icon: Icons.person,
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  BuildTextField(
                    controller: emailController,
                    label: 'emailLabel'.tr,
                    icon: Icons.email,
                    theme: theme,
                    isObscured: false,
                  ),

                  const SizedBox(height: 15),
                  //Password Text Field:
                  Obx(
                    () => BuildTextField(
                      controller: passwordController,
                      label: 'passwordLabel'.tr,
                      isPassword: true,
                      icon: Get.find<UIStateController>().isObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                      theme: theme,
                      isObscured: Get.find<UIStateController>().isObscured,
                      onIconPressed: () =>
                          Get.find<UIStateController>().toggleVisibility(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  //create account button:
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
                                  .signUpWithEmail(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    fullNameController.text.trim(),
                                  );
                              if (error != null) {
                                HelperMethods.showErrorDialog(error);
                                Navigator.pop(context);
                                return;
                              } else {
                                // login state already saved by AuthController:
                                Get.offAllNamed(AppRoutes.authWrapper);
                              }
                            },
                            child: Text(
                              'createButton'.tr,
                              style: TextStyle(
                                fontSize: 22,
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),

                  const Divider(height: 40),
                  SizedBox(
                    width: 170,
                    height: 60,
                    //Language Button:
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

                  const SizedBox(height: 40),
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
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
