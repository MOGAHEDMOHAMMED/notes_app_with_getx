import 'package:flutter/material.dart';
import 'package:notes_app_with_getx/auth_wrapper.dart';
import 'package:notes_app_with_getx/views/screens/about_developer_screen.dart';
import 'package:notes_app_with_getx/views/screens/active_notes_screen.dart';
import 'package:notes_app_with_getx/views/screens/archived_notes_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/create_user_screen.dart';
import 'package:notes_app_with_getx/views/screens/auth/login_screen.dart';
import 'package:notes_app_with_getx/views/screens/deleted_notes_secreen.dart';
import 'package:notes_app_with_getx/views/screens/edit_categories_screen.dart';
import 'package:notes_app_with_getx/views/screens/note_details.dart';
import 'package:notes_app_with_getx/views/screens/settings_screen.dart';
import '../../views/screens/about_app_screen.dart';
import '../../views/screens/waiting_screen.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.archivedNotesScreen:
        return MaterialPageRoute(builder: (_) => ArchivedNotesScreen());

      case AppRoutes.settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case AppRoutes.deletedNotesScreen:
        return MaterialPageRoute(builder: (_) => DeletedNotesScreen());

      case AppRoutes.activeNotesScreen:
        return MaterialPageRoute(builder: (_) => ActiveNoteScreen());

      case AppRoutes.createUserScreen:
        return MaterialPageRoute(builder: (_) => CreateUserScreen());

      case AppRoutes.loginUserScreen:
        return MaterialPageRoute(builder: (_) => UserLoginScreen());

      case AppRoutes.waitingScreen:
        return MaterialPageRoute(builder: (_) => WaitingScreen());

      case AppRoutes.authWrapper:
        return MaterialPageRoute(builder: (_) => AuthWrapper());

      case AppRoutes.editCategoriesScreen:
        return MaterialPageRoute(builder: (_) => EditCategoriesScreen());

      case AppRoutes.aboutAppScreen:
        return MaterialPageRoute(builder: (_) => AboutAppScreen());
      case AppRoutes.aboutDeveloperScreen:
        return MaterialPageRoute(builder: (_) => AboutDeveloperScreen());
      case AppRoutes.noteDetailsScreen:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) =>
                NoteDetails(note: args['note'], isNewNote: args['isNewNote']),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR: Route not found!')),
        );
      },
    );
  }
}
