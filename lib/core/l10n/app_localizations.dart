import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Dwaen'**
  String get appTitle;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New Note'**
  String get newNote;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleHint;

  /// No description provided for @contentHint.
  ///
  /// In en, this message translates to:
  /// **'Write your note here...'**
  String get contentHint;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @googleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get noAccount;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @createAcountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Acount'**
  String get createAcountTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get language;

  /// No description provided for @withOutTitle.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get withOutTitle;

  /// No description provided for @noDeletedNote.
  ///
  /// In en, this message translates to:
  /// **'There are no notes in Recycle Bin'**
  String get noDeletedNote;

  /// No description provided for @noArchivedNotes.
  ///
  /// In en, this message translates to:
  /// **'No archived notes'**
  String get noArchivedNotes;

  /// No description provided for @noActiveNotes.
  ///
  /// In en, this message translates to:
  /// **'No Notes'**
  String get noActiveNotes;

  /// No description provided for @activeNotesAppBar.
  ///
  /// In en, this message translates to:
  /// **'My Notes'**
  String get activeNotesAppBar;

  /// No description provided for @archivedNotesAppBar.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archivedNotesAppBar;

  /// No description provided for @deletedNoteAppBar.
  ///
  /// In en, this message translates to:
  /// **'Recycle Bin'**
  String get deletedNoteAppBar;

  /// No description provided for @ignoreNotes.
  ///
  /// In en, this message translates to:
  /// **'The empty note was ignored'**
  String get ignoreNotes;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get saveNote;

  /// No description provided for @updateNote.
  ///
  /// In en, this message translates to:
  /// **'Note was updated'**
  String get updateNote;

  /// No description provided for @archivedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Archived Success'**
  String get archivedSuccess;

  /// No description provided for @deletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted Success'**
  String get deletedSuccess;

  /// No description provided for @moveToArchived.
  ///
  /// In en, this message translates to:
  /// **'Move To Archive'**
  String get moveToArchived;

  /// No description provided for @moveToRecycleBin.
  ///
  /// In en, this message translates to:
  /// **'Move To Recycle Bin'**
  String get moveToRecycleBin;

  /// No description provided for @shareNote.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareNote;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get category;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryNameHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @editCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Categories'**
  String get editCategoriesTitle;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get update;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Change Mode'**
  String get darkMode;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LogOut'**
  String get logout;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @notesManagment.
  ///
  /// In en, this message translates to:
  /// **'Notes Managment'**
  String get notesManagment;

  /// No description provided for @welcomeback.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeback;

  /// No description provided for @devlopment.
  ///
  /// In en, this message translates to:
  /// **'Under Devlopment'**
  String get devlopment;

  /// No description provided for @availableCategories.
  ///
  /// In en, this message translates to:
  /// **'Available Categories'**
  String get availableCategories;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'With out Category'**
  String get noCategory;

  /// No description provided for @moveFromArchive.
  ///
  /// In en, this message translates to:
  /// **'Move From Archive'**
  String get moveFromArchive;

  /// No description provided for @noCategoryNotes.
  ///
  /// In en, this message translates to:
  /// **'Thes Category Not Have Notes Yet'**
  String get noCategoryNotes;

  /// No description provided for @deleteForeverSuccess.
  ///
  /// In en, this message translates to:
  /// **'Forever Deleted Successfully'**
  String get deleteForeverSuccess;

  /// No description provided for @unArchivedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Un archived Note Successfully'**
  String get unArchivedSuccess;

  /// No description provided for @recoveryNote.
  ///
  /// In en, this message translates to:
  /// **'Note retrieval'**
  String get recoveryNote;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'About Developer'**
  String get aboutDeveloper;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Software Developer | Flutter & Python'**
  String get jobTitle;

  /// No description provided for @aboutMeTitle.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMeTitle;

  /// No description provided for @aboutMeContent.
  ///
  /// In en, this message translates to:
  /// **'A software developer specializing in creating high-performance mobile applications. My work reflects a strong commitment to writing clean code and delivering an exceptional user experience.'**
  String get aboutMeContent;

  /// No description provided for @contactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfoTitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @locationValue.
  ///
  /// In en, this message translates to:
  /// **'Sanaa, Yemen'**
  String get locationValue;

  /// No description provided for @skillsInterestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills & Interests'**
  String get skillsInterestsTitle;

  /// No description provided for @emptyContentShare.
  ///
  /// In en, this message translates to:
  /// **'Can\'t share empty content'**
  String get emptyContentShare;

  /// No description provided for @sharedVia.
  ///
  /// In en, this message translates to:
  /// **'Share via Dwaen App Notes'**
  String get sharedVia;

  /// No description provided for @updateCategory.
  ///
  /// In en, this message translates to:
  /// **'Update category'**
  String get updateCategory;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Your safe space in a world full of chaos'**
  String get slogan;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
