import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationHelper {
  static StreamSubscription<QuerySnapshot>? _helpRequestsSubscription;

  // Start listening for COBSART assignments
  static void startListeningForCOBSART(BuildContext context, {Function(String message)? onMessage}) {
    // Cancel any existing subscription
    _helpRequestsSubscription?.cancel();

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Listen to Help Requests collection for changes
    _helpRequestsSubscription = FirebaseFirestore.instance
        .collection('Help Requests')
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String selectedTeam = data['selectedTeam'] ?? '';
        
        // Check if COBSART is assigned
        if (selectedTeam == 'COBSART') {
          // Get user's userID from Accounts collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('Accounts')
              .doc(user.uid)
              .get();
          
          if (userDoc.exists) {
            String userId = userDoc['userID'];
            
            // Check if this document belongs to the current user
            if (doc.id == userId) {
              // Notify parent to show message at center
              if (onMessage != null) {
                onMessage('Your Help Request is Responded! Rescue is on its way!');
              } else {
                // Fallback: show dialog at center
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => const AlertDialog(
                    content: Text('Your Help Request is Responded! Rescue is on its way!'),
                  ),
                );
              }
            }
          }
        }
      }
    });
  }

  // Stop listening for COBSART assignments
  static void stopListeningForCOBSART() {
    _helpRequestsSubscription?.cancel();
    _helpRequestsSubscription = null;
  }

  // Check if a specific help request has COBSART assigned
  static Future<bool> isCOBSARTAssigned(String documentId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Help Requests')
          .doc(documentId)
          .get();
      
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        String selectedTeam = data['selectedTeam'] ?? '';
        return selectedTeam == 'COBSART';
      }
      return false;
    } catch (e) {
      print('Error checking COBSART assignment: $e');
      return false;
    }
  }

  // Show COBSART notification manually
  static void showCOBSARTNotification(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AlertDialog(
        content: Text('Your Help Request is Responded! Rescue is on its way!'),
      ),
    );
  }
} 