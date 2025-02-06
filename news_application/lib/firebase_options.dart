// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    appId: '1:1047820903382:web:4541722adfa7ae6539ba77',
    messagingSenderId: '1047820903382',
    projectId: 'news-app-b3425',
    authDomain: 'news-app-b3425.firebaseapp.com',
    storageBucket: 'news-app-b3425.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    appId: '1:1047820903382:android:837e1e6e178ed21539ba77',
    messagingSenderId: '1047820903382',
    projectId: 'news-app-b3425',
    storageBucket: 'news-app-b3425.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    appId: '1:1047820903382:ios:a40f501a6bbf611339ba77',
    messagingSenderId: '1047820903382',
    projectId: 'news-app-b3425',
    storageBucket: 'news-app-b3425.firebasestorage.app',
    iosBundleId: 'com.example.newsApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    appId: '1:1047820903382:ios:a40f501a6bbf611339ba77',
    messagingSenderId: '1047820903382',
    projectId: 'news-app-b3425',
    storageBucket: 'news-app-b3425.firebasestorage.app',
    iosBundleId: 'com.example.newsApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    appId: '1:1047820903382:web:575b21f4fb86199139ba77',
    messagingSenderId: '1047820903382',
    projectId: 'news-app-b3425',
    authDomain: 'news-app-b3425.firebaseapp.com',
    storageBucket: 'news-app-b3425.firebasestorage.app',
  );
}
