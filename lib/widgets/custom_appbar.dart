import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Map<String, String>> children;
  final bool showProfile;
  final String guardianName;
  final Function(String) onChildSelected;

  const CustomAppBar({
    super.key,
    required this.children,
    this.showProfile = false,
    this.guardianName = '',
    required this.onChildSelected,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedChildName = '';

  @override
  void initState() {
    super.initState();
    if (widget.children.isNotEmpty) {
      selectedChildName = widget.children[0]['name']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(
          backgroundColor: const Color.fromRGBO(16, 37, 66, 1.0),
          automaticallyImplyLeading: false,
          toolbarHeight: 110,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                widget.children.map((child) {
                  bool isSelected = child['name'] == selectedChildName;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChildName = child['name']!;
                      });
                      widget.onChildSelected(selectedChildName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: Colors.white,
                                        width: 3.0,
                                      )
                                      : null,
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200],
                              child: ClipOval(
                                child: Center(
                                  child: Image.asset(
                                    child['image']!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            child['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isSelected
                                      ? const Color.fromRGBO(184, 219, 217, 1.0)
                                      : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        if (widget.showProfile)
          Positioned(
            top: 65,
            right: 16,
            child: Row(
              children: [
                Text(
                  widget.guardianName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 45,
                  child: Center(
                    child: Image.asset(
                      'assets/icons/profile_icon.png',
                      height: 60, // يمكنك تعديل هذا الحجم حسب الحاجة
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
