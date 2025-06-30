import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NeedApprovalScreen extends StatefulWidget {
  const NeedApprovalScreen({super.key});

  @override
  State<NeedApprovalScreen> createState() => _NeedApprovalScreenState();
}

class _NeedApprovalScreenState extends State<NeedApprovalScreen> {
  final CollectionReference needApprovalCollection =
      FirebaseFirestore.instance.collection('NeedApproval');
  final CollectionReference approvedUsersCollection =
      FirebaseFirestore.instance.collection('Accounts');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedUserType = 'User';

  Future<void> approveUser(DocumentSnapshot doc, String userType) async {
    try {
      final data = doc.data() as Map<String, dynamic>;
      data['userType'] = userType;
      
      // Create user in Firebase Authentication directly
      final email = data['email'];
      final password = data['password'] ?? 'changeme123'; // fallback password if not present
      
      if (email != null && email is String && email.isNotEmpty && password is String && password.isNotEmpty) {
        // Create user in Firebase Auth
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        final User? user = userCredential.user;
        if (user != null) {
          // Send email verification
          await user.sendEmailVerification();
          
          // Save user data to Firestore with the UID
          await approvedUsersCollection.doc(user.uid).set({
            
              ...data,
              'userID': user.uid,
              'dateRegistered': FieldValue.serverTimestamp(),
              'isEmailVerified': false,
              'userType': userType,
            
          });
          
          // Delete from pending approvals
          await needApprovalCollection.doc(doc.id).delete();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User approved! Email verification sent to ${user.email}'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          throw Exception('Failed to create user account');
        }
      } else {
        throw Exception('Invalid email or password data');
      }
    } catch (e) {
      String errorMessage = 'Error: $e';
      
      // Handle specific Firebase Auth errors
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Error: Email is already registered';
            break;
          case 'invalid-email':
            errorMessage = 'Error: Invalid email format';
            break;
          case 'weak-password':
            errorMessage = 'Error: Password is too weak';
            break;
          default:
            errorMessage = 'Error: ${e.message}';
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Need Approval')),
      body: StreamBuilder<QuerySnapshot>(
        stream: needApprovalCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending approvals.'));
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Text(data['email'] ?? ''),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          String userType = 'User';
                          return StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: Text(data['name'] ?? 'No Name'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Email: ${data['email'] ?? ''}'),
                                    Text('Address: ${data['address'] ?? ''}'),
                                    Text('Birth Date: ${data['dateOfBirth'] ?? ''}'),
                                    Text('Gender: ${data['gender'] ?? ''}'),
                                    Text('Phone: ${data['phoneNumber'] ?? ''}'),
                                    Text('Religion: ${data['religion'] ?? ''}'),
                                    const SizedBox(height: 12),
                                    Text('Assign user type:'),
                                    DropdownButton<String>(
                                      value: userType,
                                      items: const [
                                        DropdownMenuItem(value: 'User', child: Text('User')),
                                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          userType = val!;
                                        });
                                      },
                                    ),
                                    if (data['selfieUrl'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                backgroundColor: Colors.black,
                                                child: InteractiveViewer(
                                                  child: Image.network(data['selfieUrl']),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.network(data['selfieUrl'], height: 100),
                                        ),
                                      ),
                                    if (data['validIdUrl'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                backgroundColor: Colors.black,
                                                child: InteractiveViewer(
                                                  child: Image.network(data['validIdUrl']),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.network(data['validIdUrl'], height: 100),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await approveUser(doc, userType);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Approve'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Approve'),
                  ),
                  onTap: () {
                    // Optionally show more details
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(data['name'] ?? 'No Name'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${data['email'] ?? ''}'),
                              Text('Address: ${data['address'] ?? ''}'),
                              Text('Birth Date: ${data['dateOfBirth'] ?? ''}'),
                              Text('Gender: ${data['gender'] ?? ''}'),
                              Text('Phone: ${data['phoneNumber'] ?? ''}'),
                              Text('Religion: ${data['religion'] ?? ''}'),
                              if (data['selfieUrl'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.black,
                                          child: InteractiveViewer(
                                            child: Image.network(data['selfieUrl']),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(data['selfieUrl'], height: 100),
                                  ),
                                ),
                              if (data['validIdUrl'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          backgroundColor: Colors.black,
                                          child: InteractiveViewer(
                                            child: Image.network(data['validIdUrl']),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(data['validIdUrl'], height: 100),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
