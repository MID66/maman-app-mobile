import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/otp_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/reports_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  runApp(const MyApp());
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Dismissal System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'FFShamelSans',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionsBuilder(),
            TargetPlatform.fuchsia: NoTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/otp': (context) => OTPPage(phoneNumber: '0557461501'),
        '/reports': (context) => const ReportsPage(isInMainLayout: true),
        '/home': (context) => const HomePage(isInMainLayout: true),
        '/profile':
            (context) => ProfilePage(
              guardianName: 'عبدالرحمن عبدالله',
              isInMainLayout: true,
            ),
        '/settings':
            (context) => SettingsPage(
              guardianName: 'عبدالرحمن عبدالله',
              isInMainLayout: true,
            ),
      },
    );
  }
}
