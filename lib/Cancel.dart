import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'usermainpage.dart'; // Make sure this import path is correct for your project
import 'notification_helper.dart';

class CancelButtonExample extends StatefulWidget {
  const CancelButtonExample({super.key});

  @override
  _CancelButtonExampleState createState() => _CancelButtonExampleState();
}

class _CancelButtonExampleState extends State<CancelButtonExample> {
  String? _responseMessage; // State variable to hold the message

  @override
  void initState() {
    super.initState();
    NotificationHelper.startListeningForCOBSART(context, onMessage: (msg) {
      setState(() {
        _responseMessage = msg;
      });
    });
  }

  @override
  void dispose() {
    NotificationHelper.stopListeningForCOBSART();
    super.dispose();
  }

  Future<void> _deleteReport(BuildContext context) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently logged in.')),
        );
        return;
      }

      // Get the userID from the Accounts collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Accounts')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User document not found.')),
        );
        return;
      }

      String userId = userDoc['userID'];

      // Delete the report from Help Requests collection
      await FirebaseFirestore.instance
          .collection('Help Requests')
          .doc(userId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report cancelled successfully!')),
      );

      // Navigate to the user main page (replace as needed)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserMainPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                // Prevent canceling if a response message is shown
                if (_responseMessage != null) {
                  return;
                }
                // Show confirmation dialog
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Are you sure you want to cancel report?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  _deleteReport(context);
                }
              },
              child: Container(
                width: 335,
                height: 331,
                decoration: const BoxDecoration(
                  color: Colors.red, // Background color of the circle
                  shape: BoxShape.circle, // Make it circular
                ),
                child: const Center(
                  child: Text(
                    'Cancel Report',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 20, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_responseMessage != null)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _responseMessage = null;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _responseMessage!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CancelButtonExample(),
  ));
}
