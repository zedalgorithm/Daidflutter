import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import the geolocator package
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:daid/medical.dart';
import 'package:daid/fire.dart';
import 'package:daid/police.dart';
import 'Settings.dart';
import 'userhotlines.dart';
import 'Profiles.dart';
import 'Aboutpage.dart';
import 'notification_helper.dart';




class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  _UserMainPageState createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  String _currentAddress = 'Fetching location...'; // Default address
  Position? _currentPosition; // Store the current position
  String _userName = ''; // Initialize the user name variable
  String _userPhotoUrl = ''; // Initialize the user photo URL variable
  String _email = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch the current location when the widget is initialized
    _fetchUserName(); // Fetch the logged-in user's name
   

  }

  // Method to fetch the logged-in user's name and photo from Firestore
  void _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'] ?? 'User Name'; // Replace 'name' with the actual field in your Firestore document
          _userPhotoUrl = userDoc['photo'] ?? '';
          _email = userDoc['email'] ?? '';
          print('User Email: $_email'); // Debugging line
        });
      } else {
        print('User document does not exist'); // Debugging line
        setState(() {
          _userName = 'User Name'; // Fallback if user document does not exist
          _userPhotoUrl = ''; // Reset photo URL
          _email = '';
        });
      }
    } else {
      print('No user is logged in'); // Debugging line
      setState(() {
        _userName = 'User not logged in'; // Handle case where user is not logged in
        _userPhotoUrl = ''; // Reset photo URL
        _email = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive sizes based on screen dimensions
    final profileImageSize = screenWidth * 0.15;
    final cardSize = screenWidth * 0.40;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header
            UserAccountsDrawerHeader(
              accountName: Text(_userName),
              accountEmail: Text(_email), // Replace with dynamic email if needed
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/1.png')
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('My Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },  
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Hotlines'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UHotlinesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // User Location Info at the top
                Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    children: [
                      // Profile Image with Online Indicator
                      Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              // Open the drawer when the profile image is tapped
                              Scaffold.of(context).openDrawer();
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: profileImageSize / 2,
                                  backgroundImage: AssetImage('assets/1.png')
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: profileImageSize * 0.2,
                                    height: profileImageSize * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      // Text Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            
                            Text(
                              _currentAddress,
                              style: const TextStyle(fontSize: 10, color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.20), // Space below location info
            
                // Column of services
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top service buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle long press for POLICE
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Long pressed POLICE service')),
                                );
                              },
            
                              onLongPress: () {
            
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ReportPoliceEmergencyPage()),
            
                                );
                              },
                              child: _buildServiceButton(
                                context,
                                'assets/police.png', // Use your custom image path
                                cardSize * 0.9, // Adjusted size for the police button
                              ),
                            ),
                            const SizedBox(height: 4), // Space between button and text
                            const Text(
                              'POLICE',
                              style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold,), // Adjust text style as needed
                            ),
                          ],
                        ),
                        const SizedBox(width: 40), // Space between buttons
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle long press for FIRE
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Long pressed FIRE service')),
                                );
                              },
            
                                onLongPress: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)=> const ReportFireEmergencyPage()),
                                  );
                                },
            
                              child: _buildServiceButton(
                                context,
                                'assets/fire.png', // Use your custom image path
                                cardSize * 0.9, // Adjusted size for the fire button
                              ),
                            ),
                            const SizedBox(height: 4), // Space between button and text
                            const Text(
                              'FIRE',
                              style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold,), // Adjust text style as needed
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5), // Space between rows
                    // Medical Service
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle long press for MEDICAL
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Long pressed MEDICAL service')),
                            );
                          },
                            onLongPress: () {
                              // Navigate to the ReportEmergencyPage on long press
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ReportEmergencyPage()),
                              );
                            },
            
                          child: _buildServiceButton(
                            context,
                            'assets/medical.png', // Use your custom image path
                            cardSize * 0.9, // Adjusted size for the medical button
                          ),
                        ),
                        const SizedBox(height: 4), // Space between button and text
                        const Text(
                          'MEDICAL',
                          style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold,), // Adjust text style as needed
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fetches the current position
  Future<void> _getCurrentLocation() async {
    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        setState(() {
          _currentAddress = 'Location permissions are denied';
        });
        return;
      }
    }

    // Get the current position
    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      await _getAddressFromLatLng(_currentPosition!); // Get address from coordinates
    } catch (e) {
      setState(() {
        _currentAddress = 'Error fetching position: $e'; // Handle any errors
      });
    }
  }

  // Fetches the address from the coordinates
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      // Fetch address from coordinates using geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.subLocality ?? 'Unknown locality'} ${place.locality ?? 'Unknown locality'} '
                            '${place.administrativeArea ?? 'Unknown area'}, ${place.country ?? 'Unknown country'}';
        });
      } else {
        setState(() {
          _currentAddress = 'No address found';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Error fetching address: ${e.toString()}';
      });
    }
  }

  // New method to build service buttons with custom images without border and background
  Widget _buildServiceButton(BuildContext context, String imagePath, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Center( // Center the image within the button
        child: Image.asset(
          imagePath,
          width: size * 0.95, // Adjust the size of the image
          height: size * 0.95,
          fit: BoxFit.contain, // Maintain aspect ratio
        ),
      ),
    );
  }
}
 