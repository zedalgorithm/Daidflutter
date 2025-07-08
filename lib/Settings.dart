import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget buildSettingItem(BuildContext context, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(fontSize: 18)),
          onTap: onTap,
        ),
        Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),
      backgroundColor: const Color(0xFFF8F0F7), // Light pinkish background
      body: ListView(
        children: [
          buildSettingItem(context, "Change login email address", () {
            // Handle change email
          }),
          buildSettingItem(context, "Change password", () {
            // Handle change password
          }),
          buildSettingItem(context, "Update account details", () {
            // Handle update details
          }),
          buildSettingItem(context, "Logout", () {
           Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
          }),
        ],
      ),
    );
  }
}
