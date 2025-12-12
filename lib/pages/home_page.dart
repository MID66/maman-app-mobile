import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'add_delegate_page.dart';

class HomePage extends StatefulWidget {
  final bool isInMainLayout;
  final String? profileData; // new parameter
  static String? cachedProfileData; // new static variable to cache profile data
  const HomePage({super.key, this.isInMainLayout = false, this.profileData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  final Color primaryColor = const Color(0xFF12213D);
  final Color backgroundColor = const Color.fromRGBO(235, 235, 235, 1.0);

  late DateTime dismissalTime;
  Timer? timer;
  String timeRemaining = 'جاري حساب الوقت...';

  // Change children from final to a mutable variable.
  List<Map<String, String>> children = [
    {'name': 'سارة', 'image': 'assets/kid1.png'},
    {'name': 'محمد', 'image': 'assets/kid2.png'},
    {'name': 'نورة', 'image': 'assets/kid3.png'},
    {'name': 'عبدالله', 'image': 'assets/kid4.png'},
  ];

  String selectedStudent = 'سارة';
  final bool _showFullName = false;
  String selectedStudentFull = '';
  String selectedSchool =
      'مدرسة فيصل بن تركي الابتدائية'; // new dynamic school variable
  bool hasCalled = false; // New state variable to track if call has been made
  bool _isDismissalTime = false;
  bool isBellOn = true; // New state variable for bell toggle

  final List<Map<String, String>> delegates = [
    {'name': 'عمر', 'image': 'assets/icons/profile_icon.png'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadBellState();
    String? data = widget.profileData ?? HomePage.cachedProfileData;
    if (data != null) {
      HomePage.cachedProfileData = data;
      try {
        final userMap = jsonDecode(data);
        if (userMap['AuthorizedPickupPeople'] != null &&
            userMap['AuthorizedPickupPeople'] is List) {
          List<Map<String, dynamic>> authorizedChildren = [];
          for (var auth in userMap['AuthorizedPickupPeople']) {
            var student = auth['Student'];
            if (student != null) {
              String firstName = student['first_name'] ?? '';
              String lastName = student['last_name'] ?? '';
              String school = "";
              if (student.containsKey('School') && student['School'] != null) {
                school = student['School']['school_name'] ?? '';
              }
              authorizedChildren.add({
                "first_name": firstName,
                "last_name": lastName,
                "name": firstName,
                "full": "$firstName $lastName",
                "school": school,
                "image":
                    (student['gender'] ?? '') == "Female"
                        ? 'assets/kid1.png'
                        : 'assets/kid2.png',
                // UPDATED: use student's "student_id" as integer
                "student_id": student["student_id"] ?? 0,
              });
            }
          }
          if (authorizedChildren.isNotEmpty) {
            setState(() {
              // Cast list to List<Map<String, String>> if needed for UI but keep student_id as int
              children =
                  authorizedChildren.map((child) {
                    // Convert student_id to string for display if needed, but keep original int in separate key
                    child["student_id"] = child["student_id"];
                    return child.map(
                      (key, value) => MapEntry(key, value.toString()),
                    );
                  }).toList();
              selectedStudent = children.first["name"]!;
              selectedStudentFull = children.first["full"]!;
              selectedSchool =
                  children.first["school"]!.isNotEmpty
                      ? children.first["school"]!
                      : 'مدرسة فيصل بن تركي الابتدائية';
            });
          }
        }
      } catch (e) {
        debugPrint("Error parsing profileData: $e");
      }
    }
    _initializeDismissalTime();
    _updateTimeRemaining();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (t) => _updateTimeRemaining(),
    );
  }

  Future<void> _initializeNotifications() async {
    await NotificationService().init();
    await NotificationService().requestPermissions();
  }

  Future<void> _loadBellState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isBellOn = prefs.getBool('isBellOn') ?? true;
    });
    _scheduleOrCancelNotification();
  }

  Future<void> _toggleBell() async {
    setState(() {
      isBellOn = !isBellOn;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBellOn', isBellOn);
    _scheduleOrCancelNotification();
  }

  void _scheduleOrCancelNotification() {
    if (isBellOn) {
      final now = DateTime.now();
      if (dismissalTime.isAfter(now)) {
        NotificationService().scheduleNotification(
          id: 1,
          title: 'تنبيه الانصراف',
          body: 'حان وقت الانصراف',
          scheduledTime: dismissalTime,
        );
      }
    } else {
      NotificationService().cancelNotification(1);
    }
  }

  void _initializeDismissalTime() {
    final now = DateTime.now();
    // تعيين وقت الانصراف لليوم الحالي عند الساعة 12:00
    dismissalTime = DateTime(now.year, now.month, now.day, 23, 0, 0);
    _scheduleOrCancelNotification();
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    // إعادة التهيئة عند الساعة 8 صباحاً
    if (now.hour == 8) {
      _initializeDismissalTime();
    }
    final diff = dismissalTime.difference(now);
    if (mounted) {
      setState(() {
        if (diff.isNegative) {
          timeRemaining = 'حان وقت الانصراف';
          _isDismissalTime = true;
        } else {
          timeRemaining = _formatDuration(diff);
          _isDismissalTime = false;
          // Ensure hasCalled is false if it's not dismissal time yet
          hasCalled = false;
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hh = twoDigits(duration.inHours);
    final mm = twoDigits(duration.inMinutes.remainder(60));
    final ss = twoDigits(duration.inSeconds.remainder(60));
    return '$hh:$mm:$ss';
  }

  void updateStudentName(String name) {
    // Find child record by first name (or adjust key if needed)
    final child = children.firstWhere(
      (child) => child['name'] == name,
      orElse: () => {'name': name, 'full': name, 'school': ''},
    );
    setState(() {
      selectedStudent = child['name']!;
      selectedStudentFull = child['full']!;
      selectedSchool =
          (child['school'] != null && child['school']!.isNotEmpty)
              ? child['school']!
              : 'مدرسة فيصل بن تركي الابتدائية';
      hasCalled = false; // Reset call status when student changes
    });
  }

  void _showConfirmDialog(BuildContext context, String studentName) {
    final child = children.firstWhere(
      (child) => child['name'] == studentName,
      orElse: () => {'image': 'assets/kid1.png'},
    );
    final imagePath = child['image'] ?? 'assets/kid1.png';

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تم تأكيد استلام $studentName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(imagePath),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('رجوع'),
                ),
              ],
            ),
          ),
    );
  }

  void _showCallDialog(BuildContext context, String studentName) {
    final child = children.firstWhere(
      (child) => child['name'] == studentName,
      orElse: () => {'image': 'assets/kid1.png'},
    );
    final imagePath = child['image'] ?? 'assets/kid1.png';

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'يتم الآن نـداء $studentName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(imagePath),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('رجوع'),
                ),
              ],
            ),
          ),
    );
  }

  Widget buildContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            buildStudentInfoCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _toggleBell,
                    child: Image.asset(
                      isBellOn
                          ? 'assets/icons/bell_fill.png'
                          : 'assets/icons/bell_off.png',
                      height: 26,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'وقت الانصراف اليوم',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            buildDismissalCard(),
            buildDelegatesSection(),
          ],
        ),
      ),
    );
  }

  Widget buildStudentInfoCard() {
    final childData = children.firstWhere(
      (child) => child['name'] == selectedStudent,
      orElse: () => {'image': 'assets/kid1.png'},
    );
    final childImage = childData['image'] ?? 'assets/kid1.png';
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color.fromRGBO(184, 219, 217, 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Always show full name
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                selectedStudentFull,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                selectedSchool,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: const Color.fromRGBO(16, 37, 66, 1.0),
            radius: 35,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: ClipOval(
                child: Image.asset(childImage, fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// دالة buildDismissalCard تُعرض فيها عبارة "متبقي على الانصراف" والوقت.
  /// عند انتهاء العد (timeRemaining == 'حان وقت الانصراف')،
  /// نضيف الخاصية textAlign: TextAlign.center إلى النص داخل الحاوية
  /// دون تعديل paddingها.
  Widget buildDismissalCard() {
    final now = DateTime.now();
    final bool isTimeDone = _isDismissalTime;
    final bool isLate = now.isAfter(
      dismissalTime.add(const Duration(hours: 1)),
    );
    final String middleText =
        isTimeDone
            ? 'حان وقت خروج $selectedStudent'
            : 'متبقي على نداء $selectedStudent';
    final Color callingButtonColor = const Color.fromRGBO(16, 37, 66, 1.0);
    final Color confirmButtonColor = const Color.fromRGBO(16, 37, 66, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 350, // ارتفاع ثابت للبوكس
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    // الجزء العلوي يبقى كما هو
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'متبقي على الانصراف',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // هنا نضيف الخاصية textAlign دون تغيير padding
                              Padding(
                                padding: EdgeInsets.only(
                                  left: isTimeDone ? 12 : 50,
                                ),
                                child: Text(
                                  timeRemaining,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.alarm, size: 40, color: primaryColor),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'م',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '12:00 ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // نقل المجموعة الوسطى إلى الأسفل مع offset
                    Transform.translate(
                      offset: const Offset(0, 45),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  middleText,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (!isTimeDone)
                                Center(
                                  child: Text(
                                    timeRemaining,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      isTimeDone
                                          ? () => _dismissStudent()
                                          : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isTimeDone
                                            ? const Color.fromRGBO(
                                              184,
                                              219,
                                              217,
                                              1.0,
                                            )
                                            : callingButtonColor,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: Text(
                                    'نـداء',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          isTimeDone
                                              ? const Color.fromRGBO(
                                                16,
                                                37,
                                                66,
                                                1.0,
                                              )
                                              : Colors.black38,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      hasCalled && isTimeDone
                                          ? () => _showConfirmDialog(
                                            context,
                                            selectedStudent,
                                          )
                                          : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        hasCalled
                                            ? const Color.fromRGBO(
                                              16,
                                              37,
                                              66,
                                              1.0,
                                            )
                                            : confirmButtonColor,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: Text(
                                    'تأكيد استلام $selectedStudent',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          hasCalled
                                              ? const Color.fromRGBO(
                                                184,
                                                219,
                                                217,
                                                1.0,
                                              )
                                              : Colors.black38,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLate)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                        222,
                        226,
                        231,
                        1.0,
                      ).withOpacity(0.83),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/lock.png',
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'خارج اوقات الدوام',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.normal,
                              color: Color.fromRGBO(16, 37, 66, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDelegatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 8,
            bottom: 5,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: const Text(
              'المفوضين',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        buildDelegatesBox(),
      ],
    );
  }

  Widget buildDelegatesBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    textDirection: TextDirection.rtl,
                    children:
                        delegates
                            .map(
                              (d) =>
                                  _buildDelegateItem(d['name']!, d['image']!),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(width: 16),
                _buildAddDelegateItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddDelegateItem() {
    return SizedBox(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: const Color.fromRGBO(184, 219, 217, 1.0),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddDelegatePage(),
                  ),
                );
              },
              child: SizedBox(
                width: 70,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/plus_icon.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'إضافة مفوض ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDelegateItem(String name, String imagePath) {
    return SizedBox(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Image.asset(
                    'assets/icons/profile_icon.png',
                    height: 43,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // UPDATED: _dismissStudent now uses student_id as integer
  Future<void> _dismissStudent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final token = await user.getIdToken();
      final baseUrl = dotenv.env['API_URL_DEV'] ?? "";
      final dismissUrl = '$baseUrl/dismiss-student';
      // Retrieve student_id as integer from the selected child.
      final student = children.firstWhere(
        (child) => child['name'] == selectedStudent,
        orElse: () => {},
      );
      // Convert the stored string back to int
      final studentId = int.tryParse(student['student_id'] ?? '');
      if (studentId == null) {
        debugPrint("Invalid student_id - proceeding for UI demo");
        setState(() {
          hasCalled = true;
        });
        if (mounted) _showCallDialog(context, selectedStudent);
        return;
      }
      final response = await http.post(
        Uri.parse(dismissUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'student_id': studentId}),
      );
      if (response.statusCode == 200) {
        setState(() {
          hasCalled = true;
        });
        if (mounted) _showCallDialog(context, selectedStudent);
      } else {
        debugPrint('Dismiss failed with status: ${response.statusCode}');
        // For testing purposes, enable the button even if API fails
        setState(() {
          hasCalled = true;
        });
        if (mounted) _showCallDialog(context, selectedStudent);
      }
    } catch (e) {
      debugPrint("Dismiss error: $e");
      // For testing purposes, enable the button even if API fails
      setState(() {
        hasCalled = true;
      });
      if (mounted) _showCallDialog(context, selectedStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        children: children,
        showProfile: widget.isInMainLayout ? false : true,
        guardianName: 'عبدالرحمن عبدالله',
        onChildSelected: (childName) {
          updateStudentName(childName);
        },
      ),
      backgroundColor: backgroundColor,
      body: buildContent(),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 3,
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
              break;
          }
        },
      ),
    );
  }
}
