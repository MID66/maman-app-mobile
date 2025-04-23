import 'package:firebase_core/firebase_core.dart';
import '../config/app_config.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: AppConfig.firebaseApiKey,
        appId: AppConfig.firebaseAppId,
        messagingSenderId: AppConfig.firebaseMessagingSenderId,
        projectId: AppConfig.firebaseProjectId,
        storageBucket: AppConfig.firebaseStorageBucket,
        authDomain: AppConfig.firebaseAuthDomain,
        measurementId: AppConfig.firebaseMeasurementId,
      ),
    );
  }
}