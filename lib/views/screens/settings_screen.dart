// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/l10n/app_localizations.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageController = Get.find<LanguageController>();
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              tr.setting,
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
                              tr.language,
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
                          Selector<ThemeProvider, bool>(
                            selector: (context, ThemeProvider state) =>
                                state.isDarkMode,
                            builder: (context, isDarkMode, child) => ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDarkMode
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
                                    isDarkMode
                                        ? Icons.dark_mode_rounded
                                        : Icons.wb_sunny_rounded,
                                    key: ValueKey(
                                      isDarkMode ? 'dark' : 'light',
                                    ),
                                    color: isDarkMode
                                        ? Colors.indigoAccent
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                              title: Text(
                                tr.darkMode,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Switch(
                                value: isDarkMode,
                                activeColor: theme.colorScheme.primary,
                                onChanged: (value) async {
                                  context.read<ThemeProvider>().toggleTheme(
                                    isDarkMode,
                                  );
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('isDarkMode', value);
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
