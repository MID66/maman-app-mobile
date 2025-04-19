import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        children: [],
        showProfile: true,
        guardianName: widget.guardianName,
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
                  buildInfoRow(widget.guardianName, 'الاسم'),
                  buildInfoRow('055*******', 'رقم الجوال'),
                  buildInfoRow('ABDUL**@gmail.com', 'الإيميل'),
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

  Widget buildInfoRow(String value, String label) {
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
                  textAlign: TextAlign.left,
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
