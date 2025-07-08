import 'dart:io';
import 'package:daid/login_screen.dart';
import 'package:daid/profileliststyle.dart';
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
            leading: const Icon(Icons.menu),
            title: const Text('Back'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 228, 15, 15)),
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

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body:  Container(child: loading ? CircularProgressIndicator() : content()),
        ),
      );
  }


  Widget content(){
      return SingleChildScrollView(
        child: Column(
        children: [
          Container(
            height: 250,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/borcity.jpg'),
                fit: BoxFit.fill
                ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF902418).withAlpha(217)
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 4),
                ),
                child: ClipOval(
                  child: Image.network(
                    userData?['photo'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                        ),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
              ),
                   Positioned(
                    bottom: 50,
                    right: 110,
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: TextButton(
                        style:  TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          side: BorderSide(color: Colors.grey, width: 1.5)
                        ),
                        onPressed: (){
                          pickAndUpload();
                        }, 
                        child: Icon(Icons.camera_alt, size: 20, color: Colors.blueGrey,)
                        ),
                    )
                  ),
                   Padding(
                     padding: const EdgeInsets.only(bottom:8.0),
                     child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(userData!['name'] ?? 'N/A', 
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white)
                        )
                      ),
                   ),
                ],
              ),
            ),
          ),
         
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 2)
            ),
            child: settings(),
          )
          // settings()
        ],
        
                ),
      );
  }


  Widget settings() {
    return ListView(
      children: [
        ProfileMenuWidget(
            title: 'Update email address',
            icon: Icons.email_outlined,
            onPress: () {}),
            // const Divider(thickness: 0.5, color: Colors.grey,),
        ProfileMenuWidget(
            title: 'Change password',
            icon: Icons.password_outlined,
            onPress: () {}),
            // const Divider(thickness: 0.5, color: Colors.grey,),
        ProfileMenuWidget(
            title: 'User Management',
            icon: Icons.person_2_outlined,
            onPress: () {}),
            // const Divider(thickness: 0.5, color: Colors.grey,),
        ProfileMenuWidget(
          title: 'Logout',
          icon: Icons.logout_outlined,
          onPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          endIcon: false,
          textColor: Colors.red,
        ),
        // const Divider(thickness: 0.5, color: Colors.grey,),
      ],
    );
  }

}
