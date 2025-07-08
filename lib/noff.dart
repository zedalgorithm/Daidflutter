// // import 'dart:convert';
// // import 'package:googleapis_auth/auth_io.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:io';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // Future<String> getAccessToken() async {
// //   final accountCredentials = ServiceAccountCredentials.fromJson(
// //     File('daid/emsdirectaid-4eb037b501e6.json').readAsStringSync(),
// //   );
// //   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
// //   final client = await clientViaServiceAccount(accountCredentials, scopes);
// //   final accessToken = client.credentials.accessToken.data;
// //   client.close();
// //   return accessToken;
// // }

// // Future<String?> getFcmTokenForUser(String uid) async {
// //   final doc = await FirebaseFirestore.instance.collection('Accounts').doc(uid).get();
// //   if (doc.exists) {
// //     return doc.data()?['fcmToken'] as String?;
// //   }
// //   return null;
// // }

// // Future<void> sendFcmMessageToUser(String uid) async {
// //   final deviceFcmToken = await getFcmTokenForUser(uid);
// //   if (deviceFcmToken == null) {
// //     print('No FCM token found for user $uid');
// //     return;
// //   }

// //   final accessToken = await getAccessToken();
// //   final projectId = 'emsdirectaid'; // Your Firebase project ID

// //   final message = {
// //     "message": {
// //       "token": deviceFcmToken,
// //       "notification": {
// //         "title": "Hello",
// //         "body": "World"
// //       }
// //     }
// //   };

// //   final response = await http.post(
// //     Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
// //     headers: {
// //       'Authorization': 'Bearer $accessToken',
// //       'Content-Type': 'application/json',
// //     },
// //     body: jsonEncode(message),
// //   );

// //   print(response.body);
// // }

// // void main() {
// //   sendFcmMessageToUser('user_uid');
// // }
// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;

// Future<String> getAccessToken() async {
//   final accountCredentials = ServiceAccountCredentials.fromJson(
//     File('daid/emsdirectaid-4eb037b501e6.json').readAsStringSync(),
//   );

//   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
//   final client = await clientViaServiceAccount(accountCredentials, scopes);
//   final accessToken = client.credentials.accessToken.data;
//   client.close();
//   return accessToken;
// }

// Future<String?> getFcmTokenForUser(String uid) async {
//   final doc = await FirebaseFirestore.instance
//       .collection('Accounts')
//       .doc(uid)
//       .get();

//   if (doc.exists) {
//     return doc.data()?['fcmToken'] as String?;
//   }
//   return null;
// }

// Future<void> sendFcmMessageToUser(String uid) async {
//   final deviceFcmToken = await getFcmTokenForUser(uid);
//   if (deviceFcmToken == null) {
//     print('No FCM token found for user $uid');
//     return;
//   }

//   final accessToken = await getAccessToken();
//   const projectId = 'emsdirectaid';

//   final message = {
//     "message": {
//       "token": deviceFcmToken,
//       "notification": {
//         "title": "New Help Request",
//         "body": "Someone needs assistance."
//       }
//     }
//   };

//   final response = await http.post(
//     Uri.parse(
//         'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
//     headers: {
//       'Authorization': 'Bearer $accessToken',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(message),
//   );

//   if (response.statusCode == 200) {
//     print('Notification sent!');
//   } else {
//     print('Failed to send: ${response.statusCode} ${response.body}');
//   }
// }

// void main() async {
//   await sendFcmMessageToUser('user_uid'); // Replace with real UID
// }
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<String> getAccessToken() async {
  try {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      File('emsdirectaid-4eb037b501e6.json').readAsStringSync(),
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(accountCredentials, scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  } catch (e) {
    print('❌ Error getting access token: $e');
    rethrow;
  }
}

Future<List<String>> getAdminFcmTokens() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('Accounts')
        .where('userType', isEqualTo: 'Admin')
        .get();

    final tokens = snapshot.docs
        .map((doc) => doc.data()['fcmToken'])
        .whereType<String>()
        .toList();
    
    print('🔍 Found ${tokens.length} admin FCM tokens');
    return tokens;
  } catch (e) {
    print('❌ Error getting admin FCM tokens: $e');
    return [];
  }
}

Future<void> sendFcmToAdmins(String title, String body) async {
  try {
    final tokens = await getAdminFcmTokens();
    
    if (tokens.isEmpty) {
      print('❌ No admin FCM tokens found.');
      return;
    }

    final accessToken = await getAccessToken();
    print('🔑 Access token obtained: ${accessToken.substring(0, 20)}...');
    
    const projectId = 'emsdirectaid';

    for (final token in tokens) {
      print('📤 Sending to token: ${token.substring(0, 20)}...');
      
      final message = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
            "sound": "alert_sound",
          },
          "android": {
            "priority": "high",
            "notification": {
              "channel_id": "high_importance_channel",
              "sound": "alert_sound"
            }
          }
        }
      };

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message),
      );

      print('📊 Response: ${response.statusCode} - ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ Notification sent successfully to admin');
      } else {
        print('❌ Failed to send notification: ${response.statusCode} ${response.body}');
      }
    }
  } catch (e) {
    print('💥 Error in sendFcmToAdmins: $e');
  }
}

Future<void> sendOneSignalNotification(String title, String body) async {
  const String oneSignalAppId = 'ae747b5a-39b4-4148-abc8-4b0b7ba58b4a';
  const String oneSignalApiKey = 'os_v2_app_vz2hwwrzwraurk6ijmfxxjmljivihcmiw4tetp4wgwqg6p6wec6djcctiib6jzmwnq3zthncvry3vewyfbprfacna4lcougivbr4oli';

  final payload = {
    "app_id": oneSignalAppId,
    "included_segments": ["Admin"], // or use filters for tags
    "headings": {"en": title},
    "contents": {"en": body},
    "android_sound": "alert_sound",
    "ios_sound": "alert_sound.wav"
  };

  final response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $oneSignalApiKey',
    },
    body: jsonEncode(payload),
  );

  if (response.statusCode == 200) {
    print('✅ OneSignal notification sent!');
  } else {
    print('❌ Failed to send OneSignal notification: ${response.statusCode} ${response.body}');
  }
}

// Test function to verify FCM setup
Future<void> testFcmSetup() async {
  print('🧪 Testing FCM setup...');
  
  try {
    // Test 1: Check if we can get admin tokens
    final tokens = await getAdminFcmTokens();
    print('📱 Found ${tokens.length} admin tokens');
    
    if (tokens.isNotEmpty) {
      // Test 2: Try to get access token
      final accessToken = await getAccessToken();
      print('🔑 Access token obtained successfully');
      
      // Test 3: Send a test notification
      await sendFcmToAdmins(
        "🧪 Test Notification",
        "This is a test notification from your app",
      );
    } else {
      print('❌ No admin tokens found. Make sure admins have logged in and have FCM tokens.');
    }
  } catch (e) {
    print('💥 Test failed: $e');
  }
}

void main() async {
  try {
    print('🚀 Initializing Firebase...');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('✅ Firebase initialized successfully');
    
    // Run the test first
    await testFcmSetup();
    
    // Then start listening for new help requests
    print('🔄 Setting up Firestore listener...');
    FirebaseFirestore.instance
        .collection('Help Requests')
        .snapshots()
        .listen((snapshot) {
      for (final doc in snapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          final data = doc.doc.data();
          final requesterName = data?['userDetails']?['name'] ?? 'Someone';
          print('🚨 New help request from: $requesterName');
          
          sendFcmToAdmins(
            "🚨 New Help Request",
            "$requesterName needs assistance",
          );
        }
      }
    });

    print("🔄 Listening for new help requests...");
    print("⏰ Script will run for 10 hours...");
    await Future.delayed(Duration(hours: 10)); // Keep alive
  } catch (e) {
    print('💥 Main function error: $e');
  }
}
