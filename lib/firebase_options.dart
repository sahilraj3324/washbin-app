// File generated manually for washbin app using Firebase project: legal-ears-cd9eb
// Package: com.pitlox.legalears (temporary — will be updated to washbin package later)

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPsf-zKrJCqlXcPPcA7Nb97_fgCZ_SBtg',
    appId: '1:477837981748:android:2785c8397221f6680b7261',
    messagingSenderId: '477837981748',
    projectId: 'legal-ears-cd9eb',
    storageBucket: 'legal-ears-cd9eb.firebasestorage.app',
  );

  // iOS options — update appId and bundleId if you add an iOS app in Firebase Console
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPsf-zKrJCqlXcPPcA7Nb97_fgCZ_SBtg',
    appId:
        '1:477837981748:ios:0000000000000000000000', // placeholder — add iOS app in Firebase Console
    messagingSenderId: '477837981748',
    projectId: 'legal-ears-cd9eb',
    storageBucket: 'legal-ears-cd9eb.firebasestorage.app',
    iosBundleId: 'com.pitlox.washbin',
  );
}
