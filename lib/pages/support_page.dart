import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';

class SupportPage extends StatelessWidget {
  final String guardianName;

  const SupportPage({super.key, required this.guardianName});

  final String supportEmail = 'support@example.com';
  final String supportPhone = '+966 55 123 4567';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1.0),
      appBar: CustomAppBar(
        children: [],
        showProfile: true,
        guardianName: guardianName,
        onChildSelected: (name) {},
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'الدعم الفني',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(16, 37, 66, 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'يمكنك التواصل مع مشرفي التطبيق عبر البريد الإلكتروني أو الاتصال برقم التواصل التالي:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(16, 37, 66, 1.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Color.fromRGBO(16, 37, 66, 1.0),
                      ),
                      title: Text(
                        supportEmail,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(16, 37, 66, 1.0),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.copy,
                          size: 20,
                          color: Color.fromRGBO(184, 219, 217, 1.0),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: supportEmail));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم نسخ البريد الإلكتروني'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Color.fromRGBO(16, 37, 66, 1.0),
                      ),
                      title: Text(
                        supportPhone,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(16, 37, 66, 1.0),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.copy,
                          size: 20,
                          color: Color.fromRGBO(184, 219, 217, 1.0),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: supportPhone));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ رقم الهاتف')),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(16, 37, 66, 1.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'رجوع',
                  style: TextStyle(
                    color: Color.fromRGBO(184, 219, 217, 1.0),
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          CustomBottomNav(
            selectedIndex: 1,
            onItemTapped: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/profile');
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
        ],
      ),
    );
  }
}
