import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReportsPage extends StatefulWidget {
  final bool isInMainLayout;

  const ReportsPage({super.key, this.isInMainLayout = false});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar', null);
    if (children.isNotEmpty) {
      selectedChildName = children[0]['name']!;
      selectedSchool = children[0]['school']!;
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
    final filteredReports = getFilteredReports();
    if (filteredReports.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تقارير متاحة لهذا الطفل',
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
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return buildReportItem(
          report['name']!,
          report['time']!,
          report['description']!,
          report['date']!,
        );
      },
    );
  }

  Widget buildReportItem(
    String childName,
    String time,
    String description,
    String dateStr,
  ) {
    final dayName = getDayName(dateStr);
    final dateOnly = getDateOnly(dateStr);
    final childData = children.firstWhere(
      (child) => child['name'] == childName,
      orElse: () => {'image': 'assets/default.png'},
    );
    final childImage = childData['image'] ?? 'assets/default.png';

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اليوم: $dayName',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text(
                  'الساعة: $time',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text(
                  'التاريخ: $dateOnly',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$description $childName',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(16, 37, 66, 1.0),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage(childImage),
                            radius: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  getActionSentence(description, childName),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(16, 37, 66, 1.0),
                  ),
                  textAlign: TextAlign.right,
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
