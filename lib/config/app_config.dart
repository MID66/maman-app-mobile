import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiUrlDev => dotenv.env['API_URL_DEV'] ?? '';
  static String get apiUrlProd => dotenv.env['API_URL_PROD'] ?? '';
  
  // Firebase config
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAuthDomain => dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseStorageBucket => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';
  static String? get firebaseMeasurementId => dotenv.env['FIREBASE_MEASUREMENT_ID'];

  // Environment
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static String get apiBaseUrl => isProduction ? apiUrlProd : apiUrlDev;
}