import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String guardianName;

  const PrivacyPolicyPage({super.key, required this.guardianName});

  @override
  Widget build(BuildContext context) {
    final String policyText = '''
سياسة الخصوصية

نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. يتم جمع المعلومات من خلال التطبيق لاستخدامها فقط لأغراض تحسين تجربتك وضمان تقديم الخدمات بشكل آمن.

1. جمع البيانات: نقوم بجمع المعلومات التي تقدمها طوعاً عند استخدام التطبيق، مثل الاسم ورقم الهاتف والبريد الإلكتروني.
2. استخدام البيانات: يتم استخدام البيانات لتحسين الخدمات، التواصل مع المستخدمين، وإرسال التحديثات.
3. حماية البيانات: نتخذ التدابير الأمنية اللازمة لحماية معلوماتك من الوصول غير المصرح به.
4. مشاركة البيانات: لا نقوم بمشاركة بياناتك مع أطراف خارجية دون موافقتك.
5. حقوق المستخدم: يمكنك طلب الاطلاع على بياناتك وتصحيحها أو حذفها وفقاً للقوانين المعمول بها.

باستخدامك للتطبيق، فإنك توافق على هذه الشروط وسياسة الخصوصية الخاصة بنا.

للمزيد من الاستفسارات، يرجى التواصل معنا.
''';

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'سياسة الخصوصية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(16, 37, 66, 1.0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      policyText,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
