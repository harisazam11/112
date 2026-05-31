// ──────────────────────────────────────────────────────────────────────────────
// SETUP INSTRUCTIONS — replace the placeholder values below with your own.
//
// 1. Install FlutterFire CLI:
//      dart pub global activate flutterfire_cli
//
// 2. Log in with Firebase:
//      firebase login
//
// 3. Auto-generate this file (overwrites this template):
//      flutterfire configure
//
// Alternatively fill in the values manually from the Firebase console:
//   Project Settings → Your apps → Config
// ──────────────────────────────────────────────────────────────────────────────

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ── Replace all placeholder values below ────────────────────────────────────

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR-WEB-API-KEY',
    appId: 'YOUR-WEB-APP-ID',
    messagingSenderId: 'YOUR-MESSAGING-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    authDomain: 'YOUR-PROJECT-ID.firebaseapp.com',
    storageBucket: 'YOUR-PROJECT-ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1PJtsfFR5EkSiWT_9PHcbXvz5rCGxfTk',
    appId: '1:998914575214:android:4c36c109141a3188fb8f7f',
    messagingSenderId: '998914575214',
    projectId: 'campus-lost-and-found-7432d',
    storageBucket: 'campus-lost-and-found-7432d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-IOS-API-KEY',
    appId: 'YOUR-IOS-APP-ID',
    messagingSenderId: 'YOUR-MESSAGING-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-PROJECT-ID.appspot.com',
    iosBundleId: 'com.buitems.campusLostFound',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR-MACOS-API-KEY',
    appId: 'YOUR-MACOS-APP-ID',
    messagingSenderId: 'YOUR-MESSAGING-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    storageBucket: 'YOUR-PROJECT-ID.appspot.com',
    iosBundleId: 'com.buitems.campusLostFound',
  );
}