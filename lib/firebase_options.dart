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
    apiKey: 'AIzaSyC-tdppwuYClLawH27o0HPPl0ebqyclA5g',
    appId: '1:536589428304:web:e28365c1c8563157a1d355',
    messagingSenderId: '536589428304',
    projectId: 'gmma-v1',
    authDomain: 'gmma-v1.firebaseapp.com',
    storageBucket: 'gmma-v1.appspot.com',
    measurementId: 'G-HTW4V7Y2E0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgC1BTwuckXbtK2ZOpP-qKJ0mLkg-LtN4',
    appId: '1:536589428304:android:a46d03e70cb5e360a1d355',
    messagingSenderId: '536589428304',
    projectId: 'gmma-v1',
    storageBucket: 'gmma-v1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQ4a45NunNSRR4pBc4Ltiq6feBvK90_6Q',
    appId: '1:536589428304:ios:2c75b49e4da84e3aa1d355',
    messagingSenderId: '536589428304',
    projectId: 'gmma-v1',
    storageBucket: 'gmma-v1.appspot.com',
    androidClientId: '536589428304-chigs7lg3fhs165a5q9rg3vv7tbt8t0r.apps.googleusercontent.com',
    iosClientId: '536589428304-0gfs4tfj9rh13lg5l1d33ganvlgnj81p.apps.googleusercontent.com',
    iosBundleId: 'com.example.gmmav2.gmma',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAQ4a45NunNSRR4pBc4Ltiq6feBvK90_6Q',
    appId: '1:536589428304:ios:2c75b49e4da84e3aa1d355',
    messagingSenderId: '536589428304',
    projectId: 'gmma-v1',
    storageBucket: 'gmma-v1.appspot.com',
    androidClientId: '536589428304-chigs7lg3fhs165a5q9rg3vv7tbt8t0r.apps.googleusercontent.com',
    iosClientId: '536589428304-0gfs4tfj9rh13lg5l1d33ganvlgnj81p.apps.googleusercontent.com',
    iosBundleId: 'com.example.gmmav2.gmma',
  );
}
