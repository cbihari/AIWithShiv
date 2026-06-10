import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError('Firebase is not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBXBvolQLAnXRYyijcgcDKciYFCro_R6fA',
    appId: '1:55694799834:web:18e3096731f46bad5d06e3',
    messagingSenderId: '55694799834',
    projectId: 'aiwithshiv-dev-c4197',
    authDomain: 'aiwithshiv-dev-c4197.firebaseapp.com',
    storageBucket: 'aiwithshiv-dev-c4197.firebasestorage.app',
    measurementId: 'G-CVYK48K5W2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZE6N2hikY2hfZtRjyNEVgQhaqOC1y838',
    appId: '1:55694799834:android:906ac746689cfcac5d06e3',
    messagingSenderId: '55694799834',
    projectId: 'aiwithshiv-dev-c4197',
    storageBucket: 'aiwithshiv-dev-c4197.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZac27F5-OW-9Gs8b9HB2DOv-x-4AHx1s',
    appId: '1:55694799834:ios:82dccc07e54a2dda5d06e3',
    messagingSenderId: '55694799834',
    projectId: 'aiwithshiv-dev-c4197',
    storageBucket: 'aiwithshiv-dev-c4197.firebasestorage.app',
    iosBundleId: 'com.aiwithshiv.app',
  );
}
