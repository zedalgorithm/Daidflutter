import 'package:flutter/material.dart';
import 'signup_screen.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_page.dart';
import 'usermainpage.dart';

class LoginScreen extends StatelessWidget {
  // Define controllers
  final TextEditingController emailController;
  final TextEditingController passwordController;

  LoginScreen({super.key})
      : emailController = TextEditingController(),
        passwordController = TextEditingController();

  Future<void> _showDialog(BuildContext context, String title, String message, bool isError) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(
            color: isError ? Colors.red : Colors.green,
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/logo.png', height: 250),
              SizedBox(height: 30),
              
              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              
              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              
              // Login Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    
                    // Get user data from Firestore
                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('Accounts')
                        .doc(userCredential.user!.uid)
                        .get();

                    if (userDoc.exists) {
                      String userType = userDoc.get('userType');
                      
                      // Show success dialog first
                      await _showDialog(
                        context,
                        'Success',
                        'Login successful!',
                        false
                      );
                      
                      // Navigate based on userType
                      if (userType == 'Admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminPage()),
                        );
                      } else if (userType == 'User') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const UserMainPage()),
                        );
                      }
                    } else {
                      await _showDialog(
                        context,
                        'Error',
                        'User document not found',
                        true
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      await _showDialog(
                        context,
                        'Login Error',
                        'No user found for that email',
                        true
                      );
                    } else if (e.code == 'wrong-password') {
                      await _showDialog(
                        context,
                        'Login Error',
                        'Wrong password provided. Please try again.',
                        true
                      );
                    } else {
                      await _showDialog(
                        context,
                        'Login Error',
                        'Error: ${ 'Wrong password provided. Please try again.'}',
                        true
                      );
                    }
                  } catch (e) {
                    await _showDialog(
                      context,
                      'Error',
                      'Error: ${e.toString()}',
                      true
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade50,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Log in',
                  style: TextStyle(fontSize: 18),),
              ),
              SizedBox(height: 10),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                child: Text('Need an account? Sign up'),
              ),
              // Sign Up Link
              TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   // context,
                  //   // // MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  // );
                },
                child: Text('Forget Password'),
              ),



              
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'signup_screen.dart'; 
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'admin_page.dart';
// import 'usermainpage.dart';

// class LoginScreen extends StatelessWidget {
//   // Define controllers
//   final TextEditingController emailController;
//   final TextEditingController passwordController;

//   LoginScreen({super.key})
//       : emailController = TextEditingController(),
//         passwordController = TextEditingController();

//   Future<void> _showErrorDialog(BuildContext context, String title, String message) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(message),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo
//               Image.asset('assets/logo.png', height: 250),
//               const SizedBox(height: 30),
              
//               // Email TextField
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
              
//               // Password TextField
//               TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
              
//               // Login Button
//               ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//                       email: emailController.text.trim(),
//                       password: passwordController.text.trim(),
//                     );
                    
//                     // Get user data from Firestore
//                     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//                         .collection('Accounts')
//                         .doc(userCredential.user!.uid)
//                         .get();

//                     if (userDoc.exists) {
//                       String userType = userDoc.get('userType');
                      
//                       // Navigate based on userType
//                       if (userType == 'Admin') {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const AdminPage()),
//                         );
//                       } else if (userType == 'User') {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const UserMainPage()),
//                         );
//                       }
//                     } else {
//                       await _showErrorDialog(
//                         context,
//                         'Error',
//                         'User document not found'
//                       );
//                     }
//                   } on FirebaseAuthException catch (e) {
//                     if (e.code == 'user-not-found') {
//                       await _showErrorDialog(
//                         context,
//                         'Login Error',
//                         'No user found for that email'
//                       );
//                     } else if (e.code == 'wrong-password') {
//                       await _showErrorDialog(
//                         context,
//                         'Login Error',
//                         'Wrong password provided'
//                       );
//                     }
//                   } catch (e) {
//                     await _showErrorDialog(
//                       context,
//                       'Error',
//                       'Error: ${e.toString()}'
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey.shade50,
//                   foregroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text('Log in',
//                   style: TextStyle(fontSize: 18),),
//               ),
//               const SizedBox(height: 10),
              
//               // Sign Up Link
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SignUpScreen()),
//                   );
//                 },
//                 child: const Text('Need an account? Sign up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

