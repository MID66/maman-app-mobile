import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId; // new parameter
  const OTPPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _currentTime = 60;
  Timer? _timer;
  String? _profileData; // Added to store the profile data
  bool _isLoading = false;

  void _submitOTP() async {
    String otp = _controllers.map((c) => c.text).join();
    setState(() {
      _isLoading = true;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        final baseUrl = dotenv.env['API_URL_DEV'] ?? "";
        final profileUrl = '$baseUrl/users/profile';
        final response = await http.get(
          Uri.parse(profileUrl),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200) {
          setState(() {
            _profileData = response.body;
          });
        } else {
          debugPrint("Failed to fetch profile: ${response.statusCode}");
        }
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => HomePage(
                isInMainLayout: true,
                profileData: _profileData, // pass the API profile data
              ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } catch (e) {
      debugPrint("Sign in failed: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (int i = 0; i < 6; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 5) {
          _focusNodes[i].unfocus();
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _currentTime = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime == 0) {
        setState(() {});
        timer.cancel();
      } else {
        setState(() {
          _currentTime--;
        });
      }
    });
  }

  String get _timerText {
    final minutes = (_currentTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_currentTime % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // الخلفية بيضاء
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Image.asset(
                  'assets/logo_login_otp.png',
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                const Text(
                  'ادخل رمز التحقق المرسل اليك',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'تم ارسال رمز التحقق الى رقم الجوال ${widget.phoneNumber}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        onSubmitted: index == 5 ? (_) => _submitOTP() : null,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _currentTime > 0
                        ? 'إرسال رمز التحقق خلال $_timerText'
                        : 'يمكنك إعادة إرسال رمز التحقق مرة أخرى',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _submitOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(184, 219, 217, 1.0),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed:
                      _currentTime == 0
                          ? () {
                            _startTimer();
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _currentTime == 0
                            ? const Color.fromRGBO(16, 37, 66, 1.0)
                            : Colors.grey,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'إعادة ارسال',
                    style: TextStyle(
                      fontSize: 18,
                      color: _currentTime == 0 ? Colors.white : Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const LoginPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'تغيير رقم الجوال',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
