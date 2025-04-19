import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white, // تغيير لون الخلفية إلى الأبيض
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/profile.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            activeIcon: Image.asset(
              'assets/icons/profile_on_click.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/setting.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            activeIcon: Image.asset(
              'assets/icons/setting_on_click.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/reports.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            activeIcon: Image.asset(
              'assets/icons/reports_on_click.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            activeIcon: Image.asset(
              'assets/icons/home_on_click.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
