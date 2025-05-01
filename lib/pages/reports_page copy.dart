import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ReportsPage extends StatefulWidget {
  final bool isInMainLayout;

  const ReportsPage({super.key, this.isInMainLayout = false});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

  List<Map<String, String>> allReports = [
    {
      'name': 'عبدالله',
      'time': '08:00',
      'description': 'خروج',
      'date': '2025-03-25',
    },
    {
      'name': 'عبدالله',
      'time': '12:00',
      'description': 'دخول',
      'date': '2025-03-25',
    },
    {
      'name': 'محمد',
      'time': '08:15',
      'description': 'خروج',
      'date': '2025-03-25',
    },
  ];

  List<Map<String, String>> allNotifications = [
    {
      'title': 'تنبيه مهم',
      'description': 'غدًا نلتقي بكم في اجتماع أولياء الأمور',
      'date': '2025-11-22',
      'school': 'مدرسة التميز',
    },
    {
      'title': 'إشعار',
      'description': 'غدًا موعد تسليم الشهادات',
      'date': '2025-11-23',
      'school': 'مدرسة السلام',
    },
    {
      'title': 'إشعار',
      'description': 'مراجعة الدروس النهائية',
      'date': '2025-11-25',
      'school': 'مدرسة الإبداع',
    },
  ];


class _ReportsPageState extends State<ReportsPage> {
  int selectedTab = 0;
  String selectedChildName = 'عبدالله';
  String selectedSchool = '';

  List<Map<String, String>> children = [
    {'name': 'سارة', 'image': 'assets/kid1.png', 'school': 'مدرسة التميز'},
    {'name': 'محمد', 'image': 'assets/kid2.png', 'school': 'مدرسة السلام'},
    {'name': 'نورة', 'image': 'assets/kid3.png', 'school': 'مدرسة الإبداع'},
    {
      'name': 'عبدالله',
      'image': 'assets/kid4.png',
      'school': 'مدرسة فيصل بن تركي',
    },
  ];

  List<dynamic> parentDismissals = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar', null);
    if (children.isNotEmpty) {
      selectedChildName = children[0]['name']!;
      selectedSchool = children[0]['school']!;
    }
    fetchParentDismissals();
  }

  Future<void> fetchParentDismissals() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final token = await user.getIdToken();
    final baseUrl = dotenv.env['API_URL_DEV'] ?? "";
    final url = '$baseUrl/parent-dismissals';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        parentDismissals = jsonDecode(response.body);
      });
    } else {
      debugPrint("Error fetching parent dismissals: ${response.statusCode}");
    }
  }

  List<Map<String, String>> getFilteredReports() {
    return allReports
        .where((report) => report['name'] == selectedChildName)
        .toList();
  }

  void updateSelectedChild(String childName, String schoolName) {
    setState(() {
      selectedChildName = childName;
      selectedSchool = schoolName;
    });
  }

  String getDayName(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('EEEE', 'ar').format(date);
  }

  String getDateOnly(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('yyyy/MM/dd').format(date);
  }

  String getActionSentence(String desc, String name) {
    if (desc.contains('خروج')) {
      return 'خرج $name مع كومار';
    } else if (desc.contains('دخول')) {
      return 'دخل $name مع كومار';
    }
    return '$desc $name مع كومار';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(235, 235, 235, 1.0),
      appBar: CustomAppBar(
        children: children,
        showProfile: false,
        guardianName: 'عبدالرحمن عبدالله',
        onChildSelected: (childName) {
          final childData = children.firstWhere(
            (child) => child['name'] == childName,
          );
          updateSelectedChild(childName, childData['school']!);
        },
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(235, 235, 235, 1.0),
            child: Row(
              children: [
                buildTabItem(0, 'تقارير دخول وخروج الابن'),
                buildTabItem(1, 'إشعارات المدرسة'),
              ],
            ),
          ),
          Expanded(
            child:
                selectedTab == 0
                    ? buildReportsList()
                    : buildNotificationsList(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 2,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/home');
              break;
          }
        },
      ),
    );
  }

  Widget buildTabItem(int index, String title) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    isSelected
                        ? const Color.fromRGBO(16, 37, 66, 1.0)
                        : const Color.fromRGBO(184, 219, 217, 1.0),
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  isSelected
                      ? const Color.fromRGBO(16, 37, 66, 1.0)
                      : const Color.fromRGBO(184, 219, 217, 1.0),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReportsList() {
    if (parentDismissals.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تقارير متاحة',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromRGBO(16, 37, 66, 1.0),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: parentDismissals.length,
      itemBuilder: (context, index) {
        return _buildDismissalReportItem(parentDismissals[index]);
      },
    );
  }

  Widget _buildDismissalReportItem(Map report) {
    DateTime pickupTime = DateTime.parse(report['pickup_time']);
    String dayName = DateFormat('EEEE', 'ar').format(pickupTime);
    String timeFormatted = DateFormat('hh:mm a', 'ar').format(pickupTime);
    String firstName = report['Student']?['first_name'] ?? '';
    String gender = (report['Student']?['gender'] ?? '').toLowerCase();
    String avatar = gender == "female" ? 'assets/kid1.png' : 'assets/kid2.png';

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatar),
              radius: 25,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dayName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeFormatted,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationsList() {
    if (allNotifications.isEmpty) {
      return Center(
        child: Text(
          'لا توجد إشعارات متاحة لهذه المدرسة',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromRGBO(16, 37, 66, 1.0),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: allNotifications.length,
      itemBuilder: (context, index) {
        final n = allNotifications[index];
        return buildNotificationItem(
          n['description']!,
          n['date']!,
          n['school']!,
        );
      },
    );
  }

  Widget buildNotificationItem(String description, String date, String school) {
    final dateOnly = getDateOnly(date);
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              description,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(16, 37, 66, 1.0),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                school,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(16, 37, 66, 1.0),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'تم الإرسال في: $dateOnly',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(16, 37, 66, 1.0),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
