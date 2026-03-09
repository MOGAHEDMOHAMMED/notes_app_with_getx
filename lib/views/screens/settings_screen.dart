// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/language_controller.dart';
import '../../controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final languageController = Get.find<LanguageController>();
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              'setting'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
            backgroundColor: theme.colorScheme.onInverseSurface,
            surfaceTintColor: Colors.transparent,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withOpacity(
                          0.2,
                        ),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Column(
                        spacing: 10,
                        children: [
                          // Build Language ListTile:
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.translate_outlined),
                            ),
                            title: Text(
                              'language'.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: languageController
                                      .savedLocale()
                                      .languageCode,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  dropdownColor:
                                      theme.colorScheme.surfaceContainerHigh,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'ar',
                                      child: Text('العربية'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'en',
                                      child: Text('English'),
                                    ),
                                  ],
                                  onChanged: (value) async {
                                    if (value != null) {
                                      languageController.changeLanguage(value);
                                    }
                                  },
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              height: 1,
                              color: theme.colorScheme.outlineVariant
                                  .withOpacity(0.5),
                            ),
                          ),

                          // Build Theme ListTile:
                          Obx(
                            () => ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Get.find<ThemeController>().isDarkMode
                                      ? Colors.indigo.withOpacity(0.2)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, anim) =>
                                      RotationTransition(
                                        turns:
                                            child.key == const ValueKey('dark')
                                            ? Tween<double>(
                                                begin: 0.75,
                                                end: 1,
                                              ).animate(anim)
                                            : Tween<double>(
                                                begin: 0.75,
                                                end: 1,
                                              ).animate(anim),
                                        child: ScaleTransition(
                                          scale: anim,
                                          child: child,
                                        ),
                                      ),
                                  child: Icon(
                                    Get.find<ThemeController>().isDarkMode
                                        ? Icons.dark_mode_rounded
                                        : Icons.wb_sunny_rounded,
                                    key: ValueKey(
                                      Get.find<ThemeController>().isDarkMode
                                          ? 'dark'
                                          : 'light',
                                    ),
                                    color:
                                        Get.find<ThemeController>().isDarkMode
                                        ? Colors.indigoAccent
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                              title: Text(
                                'darkMode'.tr,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Switch(
                                value: Get.find<ThemeController>().isDarkMode,
                                activeColor: theme.colorScheme.primary,
                                onChanged: (value) {
                                  Get.find<ThemeController>().toggleTheme(
                                    value,
                                  );
                                },
                                thumbIcon:
                                    WidgetStateProperty.resolveWith<Icon?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return const Icon(
                                          Icons.nightlight_round,
                                          size: 16,
                                        );
                                      }
                                      return const Icon(
                                        Icons.wb_sunny,
                                        size: 16,
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(
                        '${languageController.savedLocale().languageCode} \n${Get.find<ThemeController>().isDarkMode}',
                      );
                    },
                    child: Icon(Icons.print),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
