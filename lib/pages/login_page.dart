import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  String selectedCountry = '🇸🇦 +966';
  final double fieldHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تغيير الخلفية إلى الأبيض
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
                'تسجيل الدخول',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: fieldHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: DropdownButton<String>(
                              value: selectedCountry,
                              isExpanded: true,
                              items:
                                  <String>[
                                    '🇸🇦 +966',
                                    '🇪🇬 +20',
                                    '🇱🇧 +961',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCountry = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // تقليل عرض الفاصل من 0.5 إلى 0.3
                  Container(
                    width: 0.1,
                    height: fieldHeight,
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 7,
                    child: SizedBox(
                      height: fieldHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            border: InputBorder.none,
                            hintText: 'رقم الجوال',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'بالضغط على "استمرار"، فإنك تؤكد موافقتك على جميع الشروط والتزامك بما ورد فيها.',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  String phone = phoneController.text.trim();
                  if (phone.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      '/otp',
                      arguments: '$selectedCountry $phone',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(16, 37, 66, 1.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'استمرار',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
