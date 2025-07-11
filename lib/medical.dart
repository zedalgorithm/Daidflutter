// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // For File
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ReportEmergencyPage extends StatefulWidget {
//   @override
//   _ReportEmergencyPageState createState() => _ReportEmergencyPageState();
// }

// class _ReportEmergencyPageState extends State<ReportEmergencyPage> {
//   int selectedButton = -1;
//   int selectedEmergencyType = -1;
//   File? _image; // Declare a variable to hold the image file

//   late GoogleMapController mapController; // Controller for the Google Map
//   LatLng _currentPosition = const LatLng(11.6072, 125.4353); // Variable to hold the current position
//   Set<Marker> _markers = {}; // Set to hold markers
//   String _currentAddress = ''; // Variable to hold the current address
//   TextEditingController _addressController = TextEditingController(); // Declare the TextEditingController
//   String? userAddress; // Variable to hold the user's address

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation(); // Get the current location when the widget is initialized
//     _getUserAddress(); // Fetch the user's address when the widget is initialized
//   }

//   Future<void> _getCurrentLocation() async {
//     // Request location permission
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//         // Handle permission denied
//         return;
//       }
//     }

//     // Get the current location
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude); // Create LatLng from Position
//       _markers.add(
//         Marker(
//           markerId: MarkerId('current_location'),
//           position: _currentPosition,
//           infoWindow: InfoWindow(title: 'You are here'), // Info window for the marker
//           draggable: true, // Make the marker draggable
//           onDragEnd: (newPosition) {
//             setState(() {
//               _currentPosition = newPosition; // Update the current position when the marker is dragged
//               _getAddressFromLatLng(newPosition); // Fetch the address from the new position
//               mapController.animateCamera(
//                 CameraUpdate.newLatLng(newPosition), // Animate camera to new position
//               );
//             });
//           },
//         ),
//       );
//       _getAddressFromLatLng(_currentPosition); // Fetch the address from the current position
//     });
//   }

//   Future<void> _getAddressFromLatLng(LatLng position) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     if (placemarks.isNotEmpty) {
//        print(placemarks[0].toJson()); 
//       setState(() {
//         _currentAddress = '${placemarks[0].street}, ${placemarks[0].subLocality ?? ''}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].country}'; // Format the address
//         _addressController.text = _currentAddress; // Update the TextEditingController
//       });
//     }
//   }

//   Future<void> _getUserAddress() async {
//     // Similar to the _getUserAddress method from UserAddress class
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         await Geolocator.openLocationSettings();
//         setState(() {
//           userAddress = "Location services are disabled.";
//         });
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//         permission = await Geolocator.requestPermission();
//         if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//           setState(() {
//             userAddress = "Location permissions are denied.";
//           });
//           return;
//         }
//       }

//       Position position = await Geolocator.getCurrentPosition();
//       String reverseGeocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAYQBD5gUFDhRQNDxd_bx-eesznMxijX8k';
//       final geocodeResponse = await http.get(Uri.parse(reverseGeocodeUrl));
//       final geocodeData = json.decode(geocodeResponse.body);

//       if (geocodeData['results'] == null || geocodeData['results'].isEmpty) {
//         setState(() {
//           userAddress = "Unable to fetch address.";
//         });
//         return;
//       }

//       String formattedAddress = geocodeData['results'][0]['formatted_address'];
//       setState(() {
//         userAddress = formattedAddress; // Update the userAddress variable
//       });
//     } catch (e) {
//       print("Error fetching user address: $e");
//       setState(() {
//         userAddress = "Error fetching data. Please try again.";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get screen dimensions
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final textScale = MediaQuery.textScaleFactorOf(context);

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(screenWidth * 0.03),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title
//               Center(
//                 child: Text(
//                   '🚑 REPORT MEDICAL EMERGENCY',
//                   style: TextStyle(
//                     fontSize: 18 * textScale,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Map Placeholder
//               Container(
//                 height: screenHeight * 0.25,
//                 width: MediaQuery.of(context).size.width,
//                 child: Stack(
//                   children: [
//                     GoogleMap(
//                       onMapCreated: (GoogleMapController controller) {
//                         mapController = controller; // Initialize the map controller
//                       },
//                       initialCameraPosition: CameraPosition(
//                         target: _currentPosition, // Use current position
//                         zoom: 14.0,
//                       ),
//                       myLocationEnabled: false, // Disable user location blue dot
//                       markers: _markers, // Set the markers on the map
//                     ),
//                     Positioned(
//                       top: 10,
//                       right: 10,
//                       child: Column(
//                         children: [
//                           // Full View Button
//                           FloatingActionButton(
//                             onPressed: () {
//                               // Logic to expand the map to full screen
//                             },
//                              mini: true,
//                             child: Icon(Icons.fullscreen),
//                             backgroundColor: Colors.white,
//                           ),
//                           SizedBox(height: 5), // Space between buttons
//                           // Current Location Button
//                           FloatingActionButton(
//                             onPressed: () async {
//                               try {
//                                 // Request location permission if not already granted
//                                 LocationPermission permission = await Geolocator.checkPermission();
//                                 if (permission == LocationPermission.denied) {
//                                   permission = await Geolocator.requestPermission();
//                                   if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//                                     // Handle permission denied
//                                     return;
//                                   }
//                                 }

//                                 // Get the current location
//                                 Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                
//                                 // Update the state immediately
//                                 setState(() {
//                                   _currentPosition = LatLng(position.latitude, position.longitude);
//                                   _markers.clear(); // Clear previous markers
//                                   // Add a new marker for the current location
//                                   _markers.add(
//                                     Marker(
//                                       markerId: MarkerId('current_location'),
//                                       position: _currentPosition,
//                                       infoWindow: InfoWindow(title: 'You are here'), // Info window for the marker
//                                       draggable: true, // Make the marker draggable
//                                       onDragEnd: (newPosition) {
//                                         setState(() {
//                                           _currentPosition = newPosition; // Update the current position when the marker is dragged
//                                           _getAddressFromLatLng(newPosition); // Fetch the address from the new position
//                                         });
//                                       },
//                                     ),
//                                   );
//                                   mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition)); // Move the camera to the current location
//                                 });

//                                 // Fetch the address immediately after setting the position
//                                 await _getAddressFromLatLng(_currentPosition);
//                               } catch (e) {
//                                 // Handle any errors, such as permission denied or location not found
//                                 print("Error getting location: $e");
//                               }
//                             },
//                             mini: true, // Set to true to make the button smaller
//                             child: Icon(
//                               Icons.my_location,
//                               size: 20, // Set the icon size
//                             ),
//                             backgroundColor: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Select Emergency
//               Text(
//                 'Select Emergency:',
//                 style: TextStyle(fontSize: 16 * textScale),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedButton = 0;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           side: selectedButton == 0
//                               ? BorderSide(color: Colors.red, width: 1)
//                               : BorderSide.none,
//                         ),
//                       ),
//                       child: Text('For Myself'),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.02),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedButton = 1;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           side: selectedButton == 1
//                               ? BorderSide(color: Colors.red, width: 1)
//                               : BorderSide.none,
//                         ),
//                       ),
//                       child: Text('For Someone'),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Location Address
//               Text(
//                 'Location Address:',
//                 style: TextStyle(fontSize: 16 * textScale),
//               ),
//               TextField(
//                 controller: _addressController, // Use the TextEditingController
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter location address',
//                 ),
//                 enabled: false, // Make the TextField non-editable
//                 maxLines: 1,
//                 minLines: 1,
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Type of Emergency
//               Text(
//                 'Type of Emergency:',
//                 style: TextStyle(fontSize: 16 * textScale),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedEmergencyType = 0;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           side: selectedEmergencyType == 0
//                               ? BorderSide(color: Colors.red, width: 2)
//                               : BorderSide.none,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(Icons.car_crash, color: Colors.red, size: screenWidth * 0.1),
//                           Text('Vehicular Accident', style: TextStyle(fontSize: 12 * textScale)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.02),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedEmergencyType = 1;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           side: selectedEmergencyType == 1
//                               ? BorderSide(color: Colors.red, width: 2)
//                               : BorderSide.none,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(Icons.medical_services, color: Colors.red, size: screenWidth * 0.1),
//                           Text('Medical Case', style: TextStyle(fontSize: 12 * textScale)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.02),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedEmergencyType = 2;
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           side: selectedEmergencyType == 2
//                               ? BorderSide(color: Colors.red, width: 2)
//                               : BorderSide.none,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(Icons.person, color: Colors.red, size: screenWidth * 0.1),
//                           Text('Trauma Case', style: TextStyle(fontSize: 12 * textScale)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // Upload Photo Section
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Upload photo of incident (optional)',
//                       style: TextStyle(fontSize: 16 * textScale),
//                     ),
//                     SizedBox(height: 8),
//                     Container(
//                       width: screenWidth * 0.15,
//                       height: screenWidth * 0.15,
//                       child: _image == null // Check if an image has been selected
//                           ? ElevatedButton(
//                               onPressed: () async {
//                                 // Pick an image from the camera
//                                 final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
//                                 if (pickedFile != null) {
//                                   setState(() {
//                                     _image = File(pickedFile.path); // Update the image variable
//                                   });
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 padding: EdgeInsets.zero,
//                                 backgroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.add_a_photo, color: Colors.black, size: screenWidth * 0.06),
//                                   Text('Upload', style: TextStyle(color: Colors.black, fontSize: 10 * textScale)),
//                                 ],
//                               ),
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.file(
//                                 _image!,
//                                 fit: BoxFit.cover,
//                               ),
//                             ), // Display the selected image
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: screenHeight * 0.02),

//               // // Display the user's address
//               // userAddress == null
//               //     ? CircularProgressIndicator() // Show loading indicator
//               //     : Text(
//               //         userAddress!,
//               //         style: TextStyle(fontSize: 18),
//               //         textAlign: TextAlign.center,
//               //       ),

//               // // Button to refresh the address
//               // ElevatedButton(
//               //   onPressed: _getUserAddress,
//               //   child: Text("Refresh Address"),
//               // ),

//               // Send Report Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: screenHeight * 0.02),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: Text('Send Report', style: TextStyle(fontSize: 16 * textScale, color: Colors.black,)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'Cancel.dart';

class ReportEmergencyPage extends StatefulWidget {
  @override
  _ReportEmergencyPageState createState() => _ReportEmergencyPageState();
}

class _ReportEmergencyPageState extends State<ReportEmergencyPage> {
  int selectedButton = -1;
  int selectedEmergencyType = -1;
  File? _image; // Declare a variable to hold the image file

  late GoogleMapController mapController; // Controller for the Google Map
  LatLng _currentPosition = const LatLng(11.6072, 125.4353); // Variable to hold the current position
  Set<Marker> _markers = {}; // Set to hold markers
  String _currentAddress = ''; // Variable to hold the current address
  TextEditingController _addressController = TextEditingController(); // Declare the TextEditingController
  String? userAddress; // Variable to hold the user's address
  String? address; // Variable to hold the address for saving
  DateTime requestDate = DateTime.now(); // Variable to hold the request date
  String timeNow = DateFormat('HH:mm:ss').format(DateTime.now()); // Variable to hold the current time
  User? currentUser; // To hold the current user
  Map<String, dynamic>? userDetails; // To hold user details

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get the current location when the widget is initialized
    _getUserAddress(); // Fetch the user's address when the widget is initialized
    _fetchUserDetails(); // Fetch user details on initialization
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        // Handle permission denied
        return;
      }
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude); // Create LatLng from Position
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: _currentPosition,
          infoWindow: InfoWindow(title: 'You are here'), // Info window for the marker
          draggable: true, // Make the marker draggable
          onDragEnd: (newPosition) {
            setState(() {
              _currentPosition = newPosition; // Update the current position when the marker is dragged
              _getAddressFromLatLng(newPosition); // Fetch the address from the new position
              mapController.animateCamera(
                CameraUpdate.newLatLng(newPosition), // Animate camera to new position
              );
            });
          },
        ),
      );
      _getAddressFromLatLng(_currentPosition); // Fetch the address from the current position
    });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
       print(placemarks[0].toJson()); 
      setState(() {
        _currentAddress = '${placemarks[0].street}, ${placemarks[0].subLocality ?? ''}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].country}'; // Format the address
        _addressController.text = _currentAddress; // Update the TextEditingController
      });
    }
  }

  Future<void> _getUserAddress() async {
    // Similar to the _getUserAddress method from UserAddress class
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() {
          userAddress = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          setState(() {
            userAddress = "Location permissions are denied.";
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      String reverseGeocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAYQBD5gUFDhRQNDxd_bx-eesznMxijX8k';
      final geocodeResponse = await http.get(Uri.parse(reverseGeocodeUrl));
      final geocodeData = json.decode(geocodeResponse.body);

      if (geocodeData['results'] == null || geocodeData['results'].isEmpty) {
        setState(() {
          userAddress = "Unable to fetch address.";
        });
        return;
      }

      String formattedAddress = geocodeData['results'][0]['formatted_address'];
      setState(() {
        userAddress = formattedAddress; // Update the userAddress variable
      });
    } catch (e) {
      print("Error fetching user address: $e");
      setState(() {
        userAddress = "Error fetching data. Please try again.";
      });
    }
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Accounts').doc(user.uid).get();
      setState(() {
        userDetails = userDoc.data() as Map<String, dynamic>; // Store user details
      });
    }
  }

  Future<void> _sendReport() async {
    String userId = userDetails?['userID'] ?? '';
    // Upload the image to Firebase Storage if available
    String? imageUrl; // Variable to hold the image URL after upload
    if (_image != null) {
      try {
        // Create a reference to the Firebase Storage with a unique filename
        final storageRef = FirebaseStorage.instance.ref().child('photos/${DateTime.now().millisecondsSinceEpoch}.jpg');
        // Upload the image file
        await storageRef.putFile(_image!);
        // Get the download URL
        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    // Prepare the data to be saved
    Map<String, dynamic> reportData = {
      'accidentType': selectedEmergencyType == 0 ? 'Vehicular Accident' : 
                      selectedEmergencyType == 1 ? 'Medical Case' : 
                      selectedEmergencyType == 2 ? 'Trauma Case' : 'Unknown',
      'address': _currentAddress, // Use the current address
      'emergencyPhoto': imageUrl, // Save the image URL if available
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
      'reportedFor': selectedButton == 0 ? 'For Myself' : 
                     selectedButton == 1 ? 'For Someone' : 'Unknown',
      'requestDate': DateFormat('MM/dd/yyyy').format(requestDate), // Format to date/month/year
      'timeNow': DateFormat('hh:mm a').format(DateTime.now()), // Format to 12-hour time
      'userDetails': {
      'address': userDetails? ["address"], // Assuming userAddress holds the user's address
      'age': userDetails?['age'], // Extract age from userDetails
      'email': userDetails?['email'], // Extract email from userDetails
      'gender': userDetails?['gender'], // Extract gender from userDetails
      'name': userDetails?['name'], // Extract name from userDetails
      'phoneNumber': userDetails?['phoneNumber'], // Extract phone number from userDetails
      'photo': userDetails?['photo'], // Extract photo URL from userDetails
      'religion': userDetails?['religion'], // Extract religion from userDetails
      'stability': userDetails?['stability'], // Extract stability from userDetails
      'token': userDetails?['token'], // Extract token from userDetails
      'userID': userDetails?['userID'], // Extract user ID from userDetails
    },
    };

    // Save the reportData to Firestore in the EMSDirectAid database
    try {
      // await FirebaseFirestore.instance.collection('Help Requests').add(reportData);
       await FirebaseFirestore.instance.collection('Help Requests').doc(userId).set(reportData);
      // Optionally show a success message or navigate away
      print("Report sent successfully!");
      // Navigate to Cancel screen after saving
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CancelButtonExample()),
      );
    } catch (e) {
      print("Error sending report: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.textScaleFactorOf(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  '🚑 REPORT MEDICAL EMERGENCY',
                  style: TextStyle(
                    fontSize: 18 * textScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Map Placeholder
              Container(
                height: screenHeight * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller; // Initialize the map controller
                      },
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition, // Use current position
                        zoom: 14.0,
                      ),
                      myLocationEnabled: false, // Disable user location blue dot
                      markers: _markers, // Set the markers on the map
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Column(
                        children: [
                          // Full View Button
                          FloatingActionButton(
                            onPressed: () {
                              // Logic to expand the map to full screen
                            },
                             mini: true,
                            child: Icon(Icons.fullscreen),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: 5), // Space between buttons
                          // Current Location Button
                          FloatingActionButton(
                            onPressed: () async {
                              try {
                                // Request location permission if not already granted
                                LocationPermission permission = await Geolocator.checkPermission();
                                if (permission == LocationPermission.denied) {
                                  permission = await Geolocator.requestPermission();
                                  if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
                                    // Handle permission denied
                                    return;
                                  }
                                }

                                // Get the current location
                                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                
                                // Update the state immediately
                                setState(() {
                                  _currentPosition = LatLng(position.latitude, position.longitude);
                                  _markers.clear(); // Clear previous markers
                                  // Add a new marker for the current location
                                  _markers.add(
                                    Marker(
                                      markerId: MarkerId('current_location'),
                                      position: _currentPosition,
                                      infoWindow: InfoWindow(title: 'You are here'), // Info window for the marker
                                      draggable: true, // Make the marker draggable
                                      onDragEnd: (newPosition) {
                                        setState(() {
                                          _currentPosition = newPosition; // Update the current position when the marker is dragged
                                          _getAddressFromLatLng(newPosition); // Fetch the address from the new position
                                        });
                                      },
                                    ),
                                  );
                                  mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition)); // Move the camera to the current location
                                });

                                // Fetch the address immediately after setting the position
                                await _getAddressFromLatLng(_currentPosition);
                              } catch (e) {
                                // Handle any errors, such as permission denied or location not found
                                print("Error getting location: $e");
                              }
                            },
                            mini: true, // Set to true to make the button smaller
                            child: Icon(
                              Icons.my_location,
                              size: 20, // Set the icon size
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Select Emergency
              Text(
                'Select Emergency:',
                style: TextStyle(fontSize: 16 * textScale),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: selectedButton == 0
                              ? BorderSide(color: Colors.red, width: 1)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text('For Myself'),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedButton = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: selectedButton == 1
                              ? BorderSide(color: Colors.red, width: 1)
                              : BorderSide.none,
                        ),
                      ),
                      child: Text('For Someone'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Location Address
              Text(
                'Location Address:',
                style: TextStyle(fontSize: 16 * textScale),
              ),
              TextField(
                controller: _addressController, // Use the TextEditingController
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter location address',
                ),
                enabled: false, // Make the TextField non-editable
                maxLines: 1,
                minLines: 1,
              ),
              SizedBox(height: screenHeight * 0.02),

              // Type of Emergency
              Text(
                'Type of Emergency:',
                style: TextStyle(fontSize: 16 * textScale),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedEmergencyType = 0;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: selectedEmergencyType == 0
                              ? BorderSide(color: Colors.red, width: 2)
                              : BorderSide.none,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.car_crash, color: Colors.red, size: screenWidth * 0.1),
                          Text('Vehicular Accident', style: TextStyle(fontSize: 12 * textScale)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedEmergencyType = 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: selectedEmergencyType == 1
                              ? BorderSide(color: Colors.red, width: 2)
                              : BorderSide.none,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.medical_services, color: Colors.red, size: screenWidth * 0.1),
                          Text('Medical Case', style: TextStyle(fontSize: 12 * textScale)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedEmergencyType = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: selectedEmergencyType == 2
                              ? BorderSide(color: Colors.red, width: 2)
                              : BorderSide.none,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.person, color: Colors.red, size: screenWidth * 0.1),
                          Text('Trauma Case', style: TextStyle(fontSize: 12 * textScale)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // Upload Photo Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Upload photo of incident (optional)',
                      style: TextStyle(fontSize: 16 * textScale),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
                      child: _image == null // Check if an image has been selected
                          ? ElevatedButton(
                              onPressed: () async {
                                // Pick an image from the camera
                                final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  setState(() {
                                    _image = File(pickedFile.path); // Update the image variable
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: Colors.black, size: screenWidth * 0.06),
                                  Text('Upload', style: TextStyle(color: Colors.black, fontSize: 10 * textScale)),
                                ],
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ), // Display the selected image
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),


              // Send Report Button
              Center(
                child: ElevatedButton(
                  onPressed: _sendReport, // Call the new method when pressed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2, vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Send Report', style: TextStyle(fontSize: 16 * textScale, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

