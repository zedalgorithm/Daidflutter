import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text('Back'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
          // Add more drawer items...
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CollectionReference accounts = FirebaseFirestore.instance.collection('Accounts');
  final currentUser = FirebaseAuth.instance.currentUser;
  bool loading = true;
  Map<String, dynamic>? userData;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    if (currentUser == null) return;
    final snapshot = await accounts.doc(currentUser!.uid).get();
    setState(() {
      userData = snapshot.data() as Map<String, dynamic>?;
      loading = false;
    });
  }

  Future<void> pickAndUpload() async {
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 512);
    if (file == null) return;

    setState(() => loading = true);
    final blob = File(file.path);
    final ref = FirebaseStorage.instance.ref('profile_pictures/${currentUser!.uid}');
    await ref.putFile(blob);
    final url = await ref.getDownloadURL();
    await accounts.doc(currentUser!.uid).update({'photo': url});
    setState(() {
      userData!['photo'] = url;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: ProfileDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: userData!['photo'] != null
                      ? NetworkImage(userData!['photo'])
                      : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: pickAndUpload,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white38,
                      child: Icon(Icons.camera_alt, size: 20),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Text(userData!['name'] ?? 'N/A', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            _infoRow('Email Address', userData!['email']),
            _infoRow('Religion', userData!['religion']),
            _infoRow('Gender', userData!['gender']),
            _infoRow('Home Address', userData!['address']),
            _infoRow('Birth Date', userData!['dateOfBirth']),
            _infoRow('Age', userData!['age'] != null ? userData!['age'].toString() : null),
            _infoRow('Phone Number', userData!['phoneNumber'] != null ? '+63${userData!['phoneNumber']}' : null),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value ?? 'N/A', style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
