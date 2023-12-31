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
    apiKey: 'AIzaSyAikB4Df612ZT2CYlecw3lo-BI97oeYLqQ',
    appId: '1:253116903593:web:f5b44d92e2d83d3fd479b8',
    messagingSenderId: '253116903593',
    projectId: 'asu-carpool-dd1a9',
    authDomain: 'asu-carpool-dd1a9.firebaseapp.com',
    storageBucket: 'asu-carpool-dd1a9.appspot.com',
    measurementId: 'G-7JVCRHPH3Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAA0FQi39tmtA1rxP1g9OhXYhu0HPFxHco',
    appId: '1:253116903593:android:8988900d693b5440d479b8',
    messagingSenderId: '253116903593',
    projectId: 'asu-carpool-dd1a9',
    storageBucket: 'asu-carpool-dd1a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDc0-5Vg7CSVF5pZZSR0fwZAeV6ezT4mec',
    appId: '1:253116903593:ios:db3b749b02c71a93d479b8',
    messagingSenderId: '253116903593',
    projectId: 'asu-carpool-dd1a9',
    storageBucket: 'asu-carpool-dd1a9.appspot.com',
    iosBundleId: 'com.example.carpool',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDc0-5Vg7CSVF5pZZSR0fwZAeV6ezT4mec',
    appId: '1:253116903593:ios:db3b749b02c71a93d479b8',
    messagingSenderId: '253116903593',
    projectId: 'asu-carpool-dd1a9',
    storageBucket: 'asu-carpool-dd1a9.appspot.com',
    iosBundleId: 'com.example.carpool',
  );
}
