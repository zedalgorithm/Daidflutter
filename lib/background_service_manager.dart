import 'dart:async';
import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BackgroundServiceManager {
  static const String _channelId = 'direct_aid_background';
  static const String _channelName = 'Direct Aid Background Service';
  static const String _channelDescription = 'Background service for Direct Aid emergency monitoring';
  static const String _foregroundChannelId = 'direct_aid_foreground';
  static const String _foregroundChannelName = 'Direct Aid Foreground Service';
  static const String _foregroundChannelDescription = 'Silent foreground service for Direct Aid';
  static const String _emergencyChannelId = 'direct_aid_emergency';
  static const String _emergencyChannelName = 'Direct Aid Emergency Alerts';
  static const String _emergencyChannelDescription = 'High priority emergency notifications with sound';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static Timer? _emergencyCheckTimer;

  // Initialize all background services
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    print('🚀 Initializing Direct Aid background services...');
    
    await _initializeNotifications();
    await _initializeBackgroundService();
  
    
    _isInitialized = true;
    print('✅ Direct Aid background services initialized successfully');
  }

  // Initialize local notifications
  static Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(initSettings);

    // Create channel for emergency notifications (with sound)
    const AndroidNotificationChannel emergencyChannel = AndroidNotificationChannel(
      _emergencyChannelId,
      _emergencyChannelName,
      description: _emergencyChannelDescription,
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound'),
      enableVibration: true,
      showBadge: true,
      enableLights: true,
      ledColor: Color.fromARGB(255, 255, 0, 0),
    );

    // Create silent channel for foreground service
    const AndroidNotificationChannel foregroundChannel = AndroidNotificationChannel(
      _foregroundChannelId,
      _foregroundChannelName,
      description: _foregroundChannelDescription,
      importance: Importance.low,
      playSound: false,
      sound: null,
      enableVibration: false,
      showBadge: false,
    );

    // Create general background channel
    const AndroidNotificationChannel backgroundChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: false,
      enableVibration: false,
      showBadge: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(emergencyChannel);
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(foregroundChannel);
        
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(backgroundChannel);
  }

  // Initialize background service (works when app is minimized)
  static Future<void> _initializeBackgroundService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: _foregroundChannelId, // Use silent channel
        initialNotificationTitle: 'Direct Aid',
        initialNotificationContent: 'Monitoring emergencies in Borongan City',
        foregroundServiceNotificationId: 888,
        autoStartOnBoot: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  // Start emergency monitoring for current session
  static void startEmergencyMonitoring() {
    // Cancel existing timer
    _emergencyCheckTimer?.cancel();
    
    // Start periodic emergency checking
    _emergencyCheckTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _checkForNewEmergencies();
    });

    // Listen to Firestore changes (only works when app is running)
    FirebaseFirestore.instance
        .collection('Help Requests')
        .snapshots()
        .listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          _handleNewEmergencyRequest(change.doc);
        }
      }
    });
  }

  // Check for new emergencies
  static Future<void> _checkForNewEmergencies() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Help Requests')
          .where('status', isEqualTo: 'pending')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 1))
          ))
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('�� Found ${snapshot.docs.length} pending emergencies');
        
        for (final doc in snapshot.docs) {
          _handleNewEmergencyRequest(doc);
        }
      }
    } catch (e) {
      print('❌ Error checking emergencies: $e');
    }
  }

  // Handle new emergency request
  static void _handleNewEmergencyRequest(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data != null) {
      final accidentType = data['accidentType'] ?? 'Emergency';
      final requesterName = data['userDetails']?['name'] ?? 'Someone';
      final address = data['address'] ?? 'Unknown location';
      
      _showEmergencyNotification(
        '🚨 New Emergency in Borongan City',
        '$accidentType request from $requesterName at $address',
      );
    }
  }

  // Show emergency notification
  static void _showEmergencyNotification(String title, String body) {
    _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'direct_aid_emergency', // Use dedicated emergency channel
          'Direct Aid Emergency Alerts',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alert_sound'),
          enableVibration: true,
          showWhen: true,
          enableLights: true,
          ledColor: Color.fromARGB(255, 255, 0, 0),
        ),
      ),
    );
  }

  // Start location tracking
  static Future<void> startLocationTracking() async {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _updateUserLocation(position);
    });
  }

  // Update user location in Firestore
  static Future<void> _updateUserLocation(Position position) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Accounts')
            .doc(user.uid)
            .update({
          'currentLocation': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          },
          'lastKnownLocation': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          },
        });
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  // Stop all background services
  static Future<void> stopAllServices() async {
    _emergencyCheckTimer?.cancel();
    
    final service = FlutterBackgroundService();
    service.invoke('stopService');
  }

  // Check if services are running
  static Future<bool> areServicesRunning() async {
    final service = FlutterBackgroundService();
    return await service.isRunning();
  }

  // Get service status
  static Future<Map<String, dynamic>> getServiceStatus() async {
    final service = FlutterBackgroundService();
    final isRunning = await service.isRunning();
    
    return {
      'backgroundService': isRunning,
      'notifications': true,
    };
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
      if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      service.setForegroundNotificationInfo(
        title: "Direct Aid is running",
        content: "Background location service is active",
      );
    }
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Start monitoring when service starts
  BackgroundServiceManager.startEmergencyMonitoring();
  await BackgroundServiceManager.startLocationTracking();

  // Keep the service alive
  Timer.periodic(const Duration(seconds: 1), (timer) {
    service.invoke('update');
  });
}

// iOS background callback
Future<bool> onIosBackground(ServiceInstance service) async {
  BackgroundServiceManager.startEmergencyMonitoring();
  return true;
}

// Emergency monitoring task
Future<void> _monitorEmergenciesTask() async {
  try {
    print('🔍 Checking for new emergencies in Borongan City...');
    
    final snapshot = await FirebaseFirestore.instance
        .collection('Help Requests')
        .where('status', isEqualTo: 'pending')
        .where('timestamp', isGreaterThan: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 1))
        ))
        .get();

    if (snapshot.docs.isNotEmpty) {
      print('�� Found ${snapshot.docs.length} pending emergencies');
      
      await _showBackgroundNotification(
        '🚨 Pending Emergencies',
        '${snapshot.docs.length} emergency requests need attention in Borongan City',
      );
    }
  } catch (e) {
    print('❌ Error in emergency monitoring task: $e');
  }
}

// Location update task
Future<void> _updateLocationTask() async {
  try {
    print('📍 Updating location...');
    
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Accounts')
          .doc(user.uid)
          .update({
        'lastKnownLocation': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        },
      });
      print('✅ Location updated successfully');
    }
  } catch (e) {
    print('❌ Error in location update task: $e');
  }
}



// Emergency response check task
Future<void> _checkEmergencyResponsesTask() async {
  try {
    print('�� Checking emergency responses...');
    
    final snapshot = await FirebaseFirestore.instance
        .collection('Help Requests')
        .where('status', isEqualTo: 'pending')
        .where('timestamp', isLessThan: Timestamp.fromDate(
          DateTime.now().subtract(const Duration(minutes: 30))
        ))
        .get();

    if (snapshot.docs.isNotEmpty) {
      print('⚠️ Found ${snapshot.docs.length} emergencies without response for 30+ minutes');
      
      await _showBackgroundNotification(
        '⚠️ Delayed Response Alert',
        '${snapshot.docs.length} emergencies in Borongan City need immediate attention',
      );
    }
  } catch (e) {
    print('❌ Error in response check task: $e');
  }
}

// Show notification from background task
Future<void> _showBackgroundNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'direct_aid_foreground', // Use string literal instead of variable
    'Direct Aid Foreground Service',
    importance: Importance.low,
    priority: Priority.low,
    icon: '@mipmap/ic_launcher',
    playSound: false,
    sound: null,
    enableVibration: false,
    showWhen: true,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  final FlutterLocalNotificationsPlugin notificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  await notificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch.remainder(100000),
    title,
    body,
    details,
  );
} 