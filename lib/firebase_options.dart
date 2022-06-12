// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDKX80mW4jE4AF3THd0oPJuErHRIxNi6i0',
    appId: '1:426442971639:web:8db6cbaf98f3a56719f6f2',
    messagingSenderId: '426442971639',
    projectId: 'myfirstapp-38fb8',
    authDomain: 'myfirstapp-38fb8.firebaseapp.com',
    storageBucket: 'myfirstapp-38fb8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfoRPRXOrFE9789Mp_LXA9FPb1Ygq0zYA',
    appId: '1:426442971639:android:660d552191f67cfc19f6f2',
    messagingSenderId: '426442971639',
    projectId: 'myfirstapp-38fb8',
    storageBucket: 'myfirstapp-38fb8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD58DPbDXT81E2NaoP6vxvIiCnadPc8fGc',
    appId: '1:426442971639:ios:cb6ae7ac42aebc7419f6f2',
    messagingSenderId: '426442971639',
    projectId: 'myfirstapp-38fb8',
    storageBucket: 'myfirstapp-38fb8.appspot.com',
    iosClientId: '426442971639-tlamj4ve8unqp23hklkb2a509fohff6q.apps.googleusercontent.com',
    iosBundleId: 'com.example.myproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD58DPbDXT81E2NaoP6vxvIiCnadPc8fGc',
    appId: '1:426442971639:ios:cb6ae7ac42aebc7419f6f2',
    messagingSenderId: '426442971639',
    projectId: 'myfirstapp-38fb8',
    storageBucket: 'myfirstapp-38fb8.appspot.com',
    iosClientId: '426442971639-tlamj4ve8unqp23hklkb2a509fohff6q.apps.googleusercontent.com',
    iosBundleId: 'com.example.myproject',
  );
}
