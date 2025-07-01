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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: Image.asset('assets/logo.png', height: 150)
                ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: const Text("Log In", 
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w800),),
               ),
                                  // Email TextField
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
                                  
                                 // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
                                  // const SizedBox(height: double.maxFinite),
                Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Align(
                  alignment: FractionalOffset.topRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   // context,
                      //   // // MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      // );
                    },
                    child: const Text('Forget Password.', 
                    style: TextStyle(color: Colors.indigoAccent),
                    ),
                  ),
                ),
                  ),
                                const Spacer(),
                              // Login Button
                            Align(
                              child: ElevatedButton(
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
              fixedSize: const Size(double.maxFinite, 50.0),
              backgroundColor: const Color(0xFFD71802),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
                                ),
                                child: const Text('Sign In',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600
              )
                ),
                              ),
                            ),
                      Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: divider()
                            ),
                       const Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 12.0, bottom: 5.0),
                child: Center(
                  child: Text('''Don't have an account yet?''', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                ),
              ),
                      createAccountBTN(context),
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

  Widget divider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey, thickness: 2.0,),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Text('or', style: TextStyle(fontSize: 16.0),),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey, thickness: 2.0,
          ),
        )
      ],
    );
  }

    Widget createAccountBTN(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            elevation: 2,
            side: const BorderSide(width: 1.5, color:  Color(0xFFD71802)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
             ),
        ),
        
        child: const Text(
          'Create an Account',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF93251A)),
        ),
        onPressed: () {
           navigateToSignUp(context);
        },
      ),
    );
  }


void navigateToSignUp(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignUpScreen()),
  );
}