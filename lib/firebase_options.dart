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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA37IZpAo9ia-u72EHFtgKN59G5WdYd8zs',
    appId: '1:779885097819:web:0ef36d08d671864d3f207e',
    messagingSenderId: '779885097819',
    projectId: 'qctt-998e6',
    authDomain: 'qctt-998e6.firebaseapp.com',
    storageBucket: 'qctt-998e6.firebasestorage.app',
    measurementId: 'G-75K194TYY5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcI32O_8z2ZsM0iwlIUI2mMtbBsMrrOQo',
    appId: '1:779885097819:android:327201f63acf5a223f207e',
    messagingSenderId: '779885097819',
    projectId: 'qctt-998e6',
    storageBucket: 'qctt-998e6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8DDM7EUHjN1kYzcXl2C_J69zOTMQ2gfs',
    appId: '1:779885097819:ios:714cb73a98bc20a43f207e',
    messagingSenderId: '779885097819',
    projectId: 'qctt-998e6',
    storageBucket: 'qctt-998e6.firebasestorage.app',
    iosBundleId: 'com.example.qctt',
  );

}