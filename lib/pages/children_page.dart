import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';

class ChildrenPage extends StatelessWidget {
  final String guardianName; // اسم ولي الأمر يُمرّر من صفحة الإعدادات

  const ChildrenPage({super.key, required this.guardianName});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية للأبناء
    final List<Map<String, String>> childrenData = [
      {
        'name': 'عبدالله',
        'stage': 'المرحلة الابتدائية',
        'class': 'الصف الخامس',
        'school': 'مدرسة النجاح',
      },
      {
        'name': 'نورة',
        'stage': 'المرحلة الإعدادية',
        'class': 'الصف الثاني',
        'school': 'مدرسة المستقبل',
      },
      {
        'name': 'سعيد',
        'stage': 'المرحلة الثانوية',
        'class': 'الصف الأول الثانوي',
        'school': 'مدرسة الأمل',
      },
    ];

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
          // محتوى الصفحة
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // عنوان الصفحة (مركز)
                  Text(
                    'الأبناء',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(16, 37, 66, 1.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // قائمة الأبناء
                  Expanded(
                    child: ListView.separated(
                      itemCount: childrenData.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final child = childrenData[index];
                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    child['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(16, 37, 66, 1.0),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        size: 16,
                                        color: const Color.fromRGBO(
                                          16,
                                          37,
                                          66,
                                          1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        child['stage'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromRGBO(
                                            16,
                                            37,
                                            66,
                                            1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.class_,
                                        size: 16,
                                        color: const Color.fromRGBO(
                                          16,
                                          37,
                                          66,
                                          1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        child['class'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromRGBO(
                                            16,
                                            37,
                                            66,
                                            1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: const Color.fromRGBO(
                                          16,
                                          37,
                                          66,
                                          1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        child['school'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromRGBO(
                                            16,
                                            37,
                                            66,
                                            1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // زر "رجوع" بدون تعديل حجم ثابت (يبقى كما هو)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
        ],
      ),
      // الشريط السفلي مع منطق التنقل المضاف
      bottomNavigationBar: CustomBottomNav(
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
    );
  }
}
