// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_getx/core/l10n/app_translations.dart';
import 'package:notes_app_with_getx/core/routes/app_routes.dart';
import 'package:notes_app_with_getx/views/screens/about_app_screen.dart';
import 'package:notes_app_with_getx/views/screens/about_developer_screen.dart';
import 'package:notes_app_with_getx/views/screens/active_notes_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/create_user_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/login_screen.dart';
import 'package:notes_app_with_getx/views/screens/edit_categories_screen.dart';
import 'package:notes_app_with_getx/views/screens/note_details.dart';
import 'package:notes_app_with_getx/views/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app_with_getx/core/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'package:notes_app_with_getx/controllers/auth_provider.dart';
import 'package:notes_app_with_getx/controllers/ui_state_provider.dart';
import 'package:notes_app_with_getx/controllers/theme_provider.dart';
import 'package:notes_app_with_getx/controllers/notes_provider.dart';
import 'package:notes_app_with_getx/controllers/language_controller.dart';
import 'package:notes_app_with_getx/views/screens/splash_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final themeProvider = ThemeProvider();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await themeProvider.loadTheme();

  // injecting controllers using GetX:
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<NotesController>(NotesController(), permanent: true);
  Get.put<LanguageController>(LanguageController(), permanent: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UIStateProvider()),
      ],
      child: const MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/', page: () => UserLoginScreen()),
        GetPage(name: AppRoutes.createUserScreen, page: () => CreateUserScreen()),
        GetPage(name: AppRoutes.activeNotesScreen, page: () => ActiveNoteScreen()),
        GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
        GetPage(name: AppRoutes.loginUserScreen, page: () => UserLoginScreen()),
        GetPage(name: AppRoutes.createUserScreen, page: () => CreateUserScreen()),
        GetPage(
          name: AppRoutes.aboutDeveloperScreen,
          page: () => AboutDeveloperScreen(),
        ),
        GetPage(name: AppRoutes.aboutAppScreen, page: () => AboutAppScreen()),
        GetPage(name: AppRoutes.noteDetailsScreen, page: () => NoteDetails()),
        GetPage(name: AppRoutes.settingsScreen, page: () => SettingsScreen()),
        GetPage(
          name: AppRoutes.editCategoriesScreen,
          page: () => EditCategoriesScreen(),
        ),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // locale: languageProvider.currentLocale,
      translations: AppTranslations(),
      locale:Get.find<LanguageController>().savedLocale(),
      fallbackLocale: Locale('ar'),
    
      initialRoute: '/',
    );
  }
}

class AppTheme {
  static const String fontFamily = 'Cairo';

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00695C),
      brightness: Brightness.light,
      primary: const Color(0xFF00695C),
      secondary: const Color(0xFFFF6F00),
      surface: const Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: true,
      backgroundColor: Color(0xFFF8F9FA),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: Color(0xFF1D1B20),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF1D1B20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shadowColor: const Color(0xFF00695C).withOpacity(0.4),
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF00695C), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF64FFDA),
      brightness: Brightness.dark,
      primary: const Color(0xFF64FFDA),
      secondary: const Color(0xFFFFAB40),
      background: const Color(0xFF0F172A),
      surface: const Color(0xFF1E293B),
      onSurface: const Color(0xFFE2E8F0),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF0F172A),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: Color(0xFFE2E8F0),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFF64FFDA)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF64FFDA),
        foregroundColor: const Color(0xFF0F172A),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF64FFDA), width: 1.5),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      selectedItemColor: Color(0xFF64FFDA),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
