import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') {
        debugPrint("Using existing Firebase app instance.");
      } else {
        debugPrint("Firebase initialization failed: $e");
        rethrow;
      }
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
      rethrow;
    }
  }
}