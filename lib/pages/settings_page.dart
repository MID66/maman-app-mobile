import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';
import 'children_page.dart';
import 'add_delegate_page.dart';
import 'support_page.dart';
import 'privacy_policy_page.dart';

class SettingsPage extends StatefulWidget {
  final String guardianName;
  final bool isInMainLayout;

  const SettingsPage({
    super.key,
    required this.guardianName,
    this.isInMainLayout = false,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isArabic = true;

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
    });
  }

  void _navigateLeftToRight(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1.0),
      appBar: CustomAppBar(
        children: [],
        showProfile: true,
        guardianName: widget.guardianName,
        onChildSelected: (name) {},
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _toggleLanguage,
                  child: Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: const Color.fromRGBO(16, 37, 66, 1.0),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isArabic ? 'ع' : 'EN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(16, 37, 66, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'الإعدادات',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(16, 37, 66, 1.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                buildSettingsOption(
                  context,
                  'الأبناء',
                  onTap: () {
                    _navigateLeftToRight(
                      context,
                      ChildrenPage(guardianName: widget.guardianName),
                    );
                  },
                ),
                buildSettingsOption(
                  context,
                  'إضافة مفوض',
                  onTap: () {
                    _navigateLeftToRight(context, const AddDelegatePage());
                  },
                ),
                buildSettingsOption(
                  context,
                  'الدعم الفني',
                  onTap: () {
                    _navigateLeftToRight(
                      context,
                      SupportPage(guardianName: widget.guardianName),
                    );
                  },
                ),
                buildSettingsOption(
                  context,
                  'سياسة الخصوصية',
                  onTap: () {
                    _navigateLeftToRight(
                      context,
                      PrivacyPolicyPage(guardianName: widget.guardianName),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // تنفيذ عملية تسجيل الخروج
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'تسجيل خروج',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(119, 2, 2, 1.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 1,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 1:
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

  Widget buildSettingsOption(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
