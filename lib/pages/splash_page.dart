import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';
import '../services/firebase_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init(); // call async initializer
  }
  
  Future<void> _init() async {
    await FirebaseService.initialize(); // ensure Firebase is initialized
    await _checkLogin();
  }
  
  Future<void> _checkLogin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      final baseUrl = dotenv.env['API_URL_DEV'] ?? "";
      final profileUrl = '$baseUrl/users/profile';
      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      String? profileData;
      if (response.statusCode == 200) {
        profileData = response.body;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(isInMainLayout: true, profileData: profileData),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...existing splash UI...
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
