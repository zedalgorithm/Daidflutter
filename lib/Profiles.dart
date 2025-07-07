import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.arrow_back),
            title: const Text('Back'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
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
  const ProfileScreen({super.key});

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
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: const ProfileDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundImage: userData!['photo'] != null
                      ? NetworkImage(userData!['photo'])
                      : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: pickAndUpload,
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white38,
                      child: Icon(Icons.camera_alt, size: 20),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(userData!['name'] ?? 'N/A', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _infoRow('Email Address', userData!['email']),
            _infoRow('Religion', userData!['religion']),
            _infoRow('Gender', userData!['gender']),
            _infoRow('Home Address', userData!['address']),
            _infoRow('Birth Date', userData!['dateOfBirth']),
            _infoRow('Age', userData!['age']?.toString()),
            _infoRow('Phone Number', userData!['phoneNumber'] != null ? '+63${userData!['phoneNumber']}' : null),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value ?? 'N/A', style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
