import 'package:flutter/material.dart';
import 'dart:convert';
import 'home_page.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  final String guardianName;
  final bool isInMainLayout;

  const ProfilePage({
    super.key,
    required this.guardianName,
    this.isInMainLayout = false,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    String? data = HomePage.cachedProfileData;
    if (data != null) {
      try {
        final userMap = jsonDecode(data);
        setState(() {
          firstName = userMap['first_name'] ?? '';
          lastName = userMap['last_name'] ?? '';
          phone = userMap['phone_number'] ?? '';
          email = userMap['email'] ?? '';
        });
      } catch (e) {
        debugPrint("Error parsing profile data in ProfilePage: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName =
        (firstName.isNotEmpty || lastName.isNotEmpty)
            ? '$firstName $lastName'.trim()
            : widget.guardianName;

    return Scaffold(
      appBar: CustomAppBar(
        children: [],
        showProfile: true,
        guardianName: displayName,
        onChildSelected: (name) {},
      ),
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'حسابي',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(16, 37, 66, 1.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildInfoRow(
                    displayName,
                    'الاسم',
                    textAlign: TextAlign.right,
                  ),
                  buildInfoRow(
                    phone.isNotEmpty ? phone : 'غير متوفر',
                    'رقم الجوال',
                  ),
                  buildInfoRow(
                    email.isNotEmpty ? email : 'غير متوفر',
                    'الإيميل',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 0,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/reports');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/home');
              break;
          }
        },
      ),
    );
  }

  Widget buildInfoRow(
    String value,
    String label, {
    TextAlign textAlign = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(235, 235, 235, 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value,
                  textAlign: textAlign,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(16, 37, 66, 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
