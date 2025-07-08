import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({Key? key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.textColor}) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;


  @override
  Widget build(BuildContext context) {
  return ListTile(
    onTap: onPress,
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(255, 238, 234, 234),
      ),
      child: Icon(icon, color: Colors.red),
    ),
    title: Text(
      title,
      style: TextStyle(color: textColor),
    ),
    trailing: endIcon
        ? Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.withAlpha(10),
            ),
            child: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 18.0,
              color: Colors.grey,
            ),
          )
        : null,
  );
  }
}