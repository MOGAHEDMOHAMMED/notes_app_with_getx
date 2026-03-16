# Dawen (دوّن) - Note Taking App with GetX

## About The Project
Dawin is a fast, responsive, and intuitive note-taking application built with Flutter.

**Learning Context:** This project is a direct extension and complete refactor of the original Dawin app. The primary goal of this repository is to practically apply and master the **GetX** ecosystem. It transitions from traditional state management (Provider) and native routing to GetX's powerful reactive state management (`Rx`, `Obx`), dependency injection (`Bindings`), and simplified route management.

🔗 **[Original Dawin App (Provider Version) - Click Here](https://github.com/MOGAHEDMOHAMMED/notes_app)**

---
## Some Screens:

<img src="https://github.com/user-attachments/assets/222b0173-3f54-4dad-ae5a-c67cab90bef3" alt="LoginScreen" width="300">
<img src="https://github.com/user-attachments/assets/fe12bcf8-67d0-4760-8ae7-6c90f9e4dacd" alt="Create Acount Screen" width="300">
<img src="https://github.com/user-attachments/assets/1e6c39e4-aac0-4cd2-a72b-01268a1e1b0d" alt="logIn With Google" width="300">

<img src="https://github.com/user-attachments/assets/72a5e0d5-5e5b-45ed-9ba8-6f06381b0710" alt="App Drawer" width="300">
<img src="https://github.com/user-attachments/assets/2f6e8280-4807-420c-b28f-9463af306b0e" alt="App Drawer" width="300">
<img src="https://github.com/user-attachments/assets/08bf42a7-2525-4fee-9fcf-2b79960bd828" alt="About Developer Screen" width="300">

<img src="https://github.com/user-attachments/assets/ec902a1c-7078-428f-8d19-98502f91ae40" alt="Active Notes Screen(Home)" width="300">

## Key Features
* **Reactive UI:** Instant UI updates without rebuilding the entire screen using GetX `Obx` and `bindStream`.
* **Authentication:** Secure Email/Password and Google Sign-In powered by Firebase Auth.
* **Real-time Synchronization:** Seamless CRUD operations (Create, Read, Update, Delete) with Cloud Firestore.
* **Smart Storage:** Fast local storage for user preferences using `GetStorage`.
* **Localization:** Built-in multi-language support (Arabic & English) using GetX Translations.
* **Theming:** Dynamic Light and Dark mode switching.
* **Categorization:** Organize notes by custom categories.
* **Archive & Trash:** Safely archive notes or move them to a recoverable deleted items list.

---

## Getting Started

Follow these instructions to set up the project locally on your machine.

### Prerequisites
* Flutter SDK (Latest stable version)
* A Firebase Account (Firebase Console)

### 1. Installation
Clone the repository and install the required packages:
```bush
git clone https://github.com/MOGAHEDMOHAMMED/notes_app_with_getx.git
cd notes_app_with_getx
flutter pub get
```
### 2. Firebase Setup
This project requires a connection to your own Firebase project.

#### A- Install the FlutterFire CLI if you haven't already:
```bash
dart pub global activate flutterfire_cli
```
#### B- Run the configuration command at the root of your project:
```bash
flutterfire configure
```
#### C- Go to the Firebase Console:
  - Authentication: Enable Email/Password and Google providers.
  - Firestore Database: Create a database and set the rules to allow read/write for authenticated users (or start in test mode).
  - Project Settings: Add your SHA-1 fingerprint to your Android app settings to enable Google Sign-In.
### 3. Generate App Icons
To apply the custom app icons configured in flutter_launcher_icons.yaml, run:

```bash
dart run flutter_launcher_icons
```
### 4. Generate Native Splash Screen
  To apply the native splash screen configured in flutter_native_splash.yaml, run:

```bash
dart run flutter_native_splash:create
```
### 5. Run the App
You are all set! Run the application on your preferred emulator or physical device:
```bash
flutter run
```
