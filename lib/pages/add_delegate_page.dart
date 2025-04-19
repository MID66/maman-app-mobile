import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottom_nav.dart';

class AddDelegatePage extends StatefulWidget {
  const AddDelegatePage({super.key});

  @override
  State<AddDelegatePage> createState() => _AddDelegatePageState();
}

class _AddDelegatePageState extends State<AddDelegatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<String> _childList = ['عبدالله', 'محمد', 'نورة'];
  String _selectedChild = 'عبدالله';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        children: [],
        showProfile: true,
        guardianName: 'عبدالرحمن عبدالله',
        onChildSelected: (_) {},
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'إضافة مفوض',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(16, 37, 66, 1.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  buildTextField(label: 'الاسم', controller: _nameController),
                  const SizedBox(height: 16),
                  buildTextField(
                    label: 'رقم الجوال',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الابن المفوض له',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedChild,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedChild = newValue!;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return _childList.map((String item) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    items:
                        _childList.map((childName) {
                          return DropdownMenuItem<String>(
                            value: childName,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(childName),
                            ),
                          );
                        }).toList(),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    dropdownColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إضافة المفوض بنجاح'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(184, 219, 217, 1.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(
                          color: Color.fromRGBO(16, 37, 66, 1.0),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
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

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}
