import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:daid/Report.dart';
import 'login_screen.dart';
import 'incidentreport.dart';
import 'Settings.dart';
// import 'scan_qr.dart';
import 'hotlines.dart';
import 'Profiles.dart';
import 'Aboutpage.dart';
import 'needapproval.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'background_service_manager.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(12.0667, 125.4500); // Default to Borongan City
  Set<Marker> _markers = {};
  Map<String, dynamic>? userDetails; // To hold user details
  String emergencyPhoto = 'https://example.com/default_image.jpg'; // Default value
  ValueNotifier<String> selectedTeamNotifier = ValueNotifier(''); // Use ValueNotifier for selected team
  Map<String, bool> teamAssignmentState = {};
  String selectedTeam = '';
  String message = '';
  Set<String> _knownHelpRequestIds = {};
  late FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initLocalNotifications();
    _initializeOneSignal();
    _getCurrentLocation();
    _fetchUserDetails();
    _fetchHelpRequests();
    initFCM();
    
    // Start enhanced background monitoring for admins
    BackgroundServiceManager.startEmergencyMonitoring();
    BackgroundServiceManager.startLocationTracking();
    
    // Check service status
    _checkServiceStatus();
  }

  void _initializeOneSignal() {
    OneSignal.initialize("ae747b5a-39b4-4148-abc8-4b0b7ba58b4a");
    OneSignal.Notifications.requestPermission(true);
    OneSignal.User.addTags({"role": "Admin"});
    
    // Set up OneSignal notification handlers
    OneSignal.Notifications.addClickListener((event) {
      print('🔔 OneSignal notification clicked: ${event.notification.title}');
      // Handle notification click - you can navigate to specific screens here
    });
    
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print('🔔 OneSignal foreground notification: ${event.notification.title}');
      // Show the notification as a banner
      event.notification.display(); // This line shows the in-app notification banner
    });

   
  }

  // Send OneSignal notification for new help requests
  void _sendOneSignalNotification(String accidentType, String requesterName, String address) {
    try {
      // Create notification content
      String title = '🚨 New $accidentType Emergency';
      String body = 'Request from $requesterName at $address';
      
      
      // For OneSignal, we typically send notifications from the server side
      // But we can show a local notification using flutter_local_notifications
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            sound: RawResourceAndroidNotificationSound('alert_sound'),
          ),
        ),
      );
      
      print('🔔 Local notification sent: $title');
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permissions are permanently denied');
        return;
      }

      // Get current position with high accuracy settings
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation, // Most accurate
        timeLimit: const Duration(seconds: 15), // Timeout after 15 seconds
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _addMarker();
      });

      // Animate camera to new position
      if (mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
      }

      print('📍 Location updated: ${position.latitude}, ${position.longitude}');
      print('📍 Accuracy: ${position.accuracy} meters');
    } catch (e) {
      print('❌ Error getting location: $e');
      // Fallback to default location if needed
    }
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).get();
      setState(() {
        userDetails = userDoc.data() as Map<String, dynamic>?; // Store user details
      });
    }
  }

  Future<void> _fetchHelpRequests() async {
    FirebaseFirestore.instance.collection('Help Requests').snapshots().listen((snapshot) async {
      Set<Marker> newMarkers = {};
      for (var doc in snapshot.docs) {
        var data = doc.data();
        String documentId = doc.id;

        if (data['latitude'] != null && data['longitude'] != null) {
          LatLng position = LatLng(data['latitude'], data['longitude']);
          String requesterName = data['userDetails']?['name'] ?? 'Unknown';
          String accidentType = data['accidentType'] ?? 'Unknown';
          String address = data['address'] ?? 'No address provided';
          String requestDate = data['requestDate'] ?? '';
          String timeNow = data['timeNow'] ?? '';
          String coordinates = '${data['latitude']}, ${data['longitude']}';
          String? emergencyPhoto = data['emergencyPhoto'];
          String selectedTeam = data['selectedTeam'] ?? '';

          BitmapDescriptor icon;
          if (selectedTeam == 'COBSART') {
            icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              'assets/markers/medicalresponded.png',
            );
          } else if (selectedTeam == 'BFP') {
            icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              'assets/markers/flame responded.png',
            );
          } else if (selectedTeam == 'POLICE') {
            icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              'assets/markers/polician responded.png',
            );
          } else {
            switch (accidentType) {
              case 'Fire':
                icon = await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(48, 48)),
                  'assets/markers/flamegeneric.png',
                );
                break;
              case 'Crime':
                icon = await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(48, 48)),
                  'assets/markers/police.png',
                );
                break;
              case 'Vehicular Accident':
                icon = await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(300, 300)),
                  'assets/markers/vehicle.png',
                );
                break;
              case 'Medical Case':
                icon = await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(48, 48)),
                  'assets/markers/medicalgeneric.png',
                );
                break;
              case 'Trauma Case':
                icon = await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(48, 48)),
                  'assets/markers/trauma.png',
                );
                break;
              default:
                icon = await BitmapDescriptor.fromAssetImage(
                  const ImageConfiguration(size: Size(48, 48)),
                  'assets/default_icon.png',
                );
            }
          }

          // Add marker
          newMarkers.add(
            Marker(
              markerId: MarkerId(documentId),
              position: position,
              icon: icon,
              infoWindow: InfoWindow(
                title: 'Accident Type - $accidentType',
                snippet: 'Requested by - $requesterName',
                onTap: () {
                  _showBottomSheet(
                    context,
                    data['description'] ?? 'Help Request',
                    accidentType,
                    requesterName,
                    coordinates,
                    address,
                    requestDate,
                    timeNow,
                    documentId,
                    emergencyPhoto,
                  );
                },
              ),
            ),
          );

          // ✅ Send OneSignal Notification ONLY for new docs
          if (!_knownHelpRequestIds.contains(documentId)) {
            _knownHelpRequestIds.add(documentId);
            
            // Send OneSignal notification for new help request
            _sendOneSignalNotification(accidentType, requesterName, address);
          }
        }
      }

      setState(() {
        _markers = newMarkers;
      });
    });
  }

  Future<BitmapDescriptor> getCustomMarker(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List bytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  Future<void> _addMarker() async {
    final BitmapDescriptor markerIcon = await getCustomMarker('assets/ambulance.png');

    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentPosition,
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: markerIcon,
      ),
    );

    setState(() {}); // Update the state to refresh the markers
  }

  void _showBottomSheet(BuildContext context, String title, String accidentType, String requesterName, String coordinates, String address, String requestDate, String timeNow, String documentId,  String? emergencyPhoto) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    accidentType,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

              // Logo Section
              if (emergencyPhoto != null && emergencyPhoto.isNotEmpty) 
                Image.network(
                  emergencyPhoto, // Use the emergencyPhoto URL from Help Requests
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image not available'); // Fallback if the image fails to load
                  },
                )
              else 
                const Text('Image not available'), // Display this if emergencyPhoto is null or empty
              const SizedBox(height: 20),

              // Assign Rescue Team Section
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                children: [
                  const Text(
                    'Assign Rescue Team:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _teamButton('COBSART', documentId),
                  _teamButton('BFP', documentId),
                  _teamButton('POLICE', documentId),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: teamAssignmentState[documentId] == true
                      ? Colors.red // Cancel button color 
                      : Colors.green, // Respond button color 
                  shape: RoundedRectangleBorder( 
                    borderRadius: BorderRadius.circular(10), 
                  ),
                ),
                onPressed: () async {
                  if (teamAssignmentState[documentId] == true) {
                    // Cancel the response and allow the user to select again
                    setState(() {
                      selectedTeamNotifier.value = ''; // Clear the selected team, allowing selection again
                      teamAssignmentState[documentId] = false; // Reset the state for this document
                    });

                    // Optionally reset the 'selectedTeam' field in Firestore to null or empty
                    await FirebaseFirestore.instance
                        .collection('Help Requests')
                        .doc(documentId)
                        .update({
                      'selectedTeam': FieldValue.delete(),  // Remove the selected team from Firestore
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Response canceled for marker $documentId. You can select again.')),
                    );
                  } else {
                    // Get the selected team
                    String selectedTeam = selectedTeamNotifier.value;

                    // Check if a team is selected
                    if (selectedTeam.isNotEmpty) {
                      try {
                        // Save to Firestore
                        await FirebaseFirestore.instance
                            .collection('Help Requests')
                            .doc(documentId) // Update the specific document
                            .update({
                          'selectedTeam': selectedTeam,
                          
                        });

                        // Update state for the specific document
                        setState(() {
                          teamAssignmentState[documentId] = true; // Mark as responded
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Team $selectedTeam assigned to marker $documentId.')),
                        );
                      } catch (e) {
                        // Handle errors (e.g., document not found)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error assigning team: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a team to respond.')),
                      );
                    }
                  }
                },
                child: Text(
                  teamAssignmentState[documentId] == true ? 'Cancel' : 'Respond', // Toggle text based on state
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   _actionButton(Icons.description, 'Report', null, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IncidentReportScreen(documentId: documentId)), // Ensure you import the Report class
                    );
                  }),
                  _actionButton(Icons.call, 'Call', null, null),
                  _actionButton(Icons.image, 'View', emergencyPhoto, null),
                  _actionButton(Icons.delete, 'Delete', null, null),
                ],
              ),
              const SizedBox(height: 20),

                // Requester Details Section
                Container(
                  padding: const EdgeInsets.all(0), // Remove all padding
                  alignment: Alignment.topLeft, // Align content to the top left
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (left)
                    mainAxisAlignment: MainAxisAlignment.start, // Ensure vertical alignment starts at the top
                    children: [
                      _detailItem('Requester Name:', requesterName),
                      _detailItem('Coordinate:', coordinates),
                      _detailItem('Address:', address),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _detailItem('Date:', requestDate),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _detailItem('Time:', timeNow),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> _getSelectedTeamFromFirestore(String documentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Help Requests')
        .doc(documentId)
        .get();
    var data = doc.data() as Map<String, dynamic>;
    return data['selectedTeam'] ?? ''; // Return the selectedTeam value or an empty string if not found
  }

  Widget _teamButton(String team, String documentId) {
    return FutureBuilder<String>(
      future: _getSelectedTeamFromFirestore(documentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading while fetching data
        }

        if (snapshot.hasError) {
          return Text("Error loading team data!"); // Handle potential errors
        }

        // Set the initial value of the notifier only once, when Firestore data is loaded
        if (selectedTeamNotifier.value.isEmpty && snapshot.hasData) {
          selectedTeamNotifier.value = snapshot.data!;
        }

        return ValueListenableBuilder<String>(
          valueListenable: selectedTeamNotifier, // Listen to changes in selection
          builder: (context, selectedTeam, _) {
            bool isSelected = selectedTeam == team; // Check if this team is selected

            // Define colors based on selection state
            Color backgroundColor = isSelected ? Colors.orange : Colors.white;
            Color textColor = isSelected ? Colors.white : Colors.black;
            Color borderColor = isSelected ? Colors.orangeAccent : Colors.grey.shade300;

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50), // Adjust button size as needed
                backgroundColor: backgroundColor, // Highlight selected team
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: borderColor), // Border color based on selection
                ),
              ),
              onPressed: () {
                // Update the selected team on button press
                selectedTeamNotifier.value = team;
              },
              child: Text(
                team,
                style: TextStyle(
                  color: textColor, // Text color based on selection
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  // Helper for Action Buttons
  Widget _actionButton(IconData icon, String label, String? emergencyPhoto, VoidCallback? onPressed) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(60, 60),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed ?? () {
            if (label == 'View' && emergencyPhoto != null) {
              _showFullImage(emergencyPhoto); // Show the full image
            } else {
              // Handle other action button clicks
            }
          },
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }

  // Function to show the full image in a dialog
  void _showFullImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300, // Adjust height as needed
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper for Details Section
  Widget _detailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  
  Future<void> initFCM() async {
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');

      String? token = await _messaging.getToken();
      print("📱 FCM Token: $token");

      User? user = FirebaseAuth.instance.currentUser;
      if (token != null && user != null) {
        await FirebaseFirestore.instance
            .collection('Accounts')
            .doc(user.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
      }

      _messaging.onTokenRefresh.listen((newToken) async {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('Accounts')
              .doc(user.uid)
              .set({'fcmToken': newToken}, SetOptions(merge: true));
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('🔔 Foreground FCM message received');

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                playSound: true,
                sound: RawResourceAndroidNotificationSound('alert_sound'),
              ),
            ),
          );
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notification?.title ?? 'New notification received'),
          ),
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('📲 App opened from FCM notification');
        // Optionally navigate or handle data
      });
    } else {
      print('❌ Notification permission denied');
    }
  }

  void _initLocalNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(initSettings);

    // Create channel for Android 8+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert_sound.mp3'),
      enableVibration: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _checkServiceStatus() async {
    final status = await BackgroundServiceManager.getServiceStatus();
    print('🔄 Background service status: $status');
  }

  @override
  void dispose() {
    // Don't stop background services for admins - they should continue monitoring
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader( 
              accountName: Text(userDetails?['name'] ?? 'Guest User'), // Default to Guest User
              accountEmail: Text(userDetails?['email'] ?? 'No email provided'), // Handle null email
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    userDetails?['photo'] ?? 'https://example.com/default_image.jpg'), // Use user's photo URL or a default image // Replace with your image URL
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Emergency'),
              subtitle: const Text('Map'),
              onTap: () {
                // Handle map navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Hotlines'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HotlinesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Incident Report'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RespondedRequestsList()),
                );
              },
            ),

           
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Account'),
              subtitle: const Text('Profile'),
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
           ListTile(
              leading: const Icon(Icons.approval),
              title: const Text('Approve Accounts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NeedApprovalScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
             
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack( // Use Stack to overlay widgets
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 12,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      // Optionally move the camera to the current position
                      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
                    },
                  ),
                ),
              ],
            ),
            Positioned( // Position the location icon
              top: 5, // Adjust top position
              right: 5, // Adjust right position
              child: IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white, size: 30), // Location icon
                onPressed: () async {
                  await _addMarker();
                  // Move the camera to the current location
                  mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> ensureLocationPermissions() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return;
  }
  // Permissions granted, continue.
}