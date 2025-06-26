import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
// import 'usermainpage.dart';
// import 'medical.dart';
// import 'fire.dart';
// import "police.dart";
// import "Cancel.dart";
// import 'Report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      // home:  UserMainPage(),
        // home: ReportFireEmergencyPage(),
      //  home: ReportEmergencyPage(),
        // home: ReportPoliceEmergencyPage(),
        // home: CancelButtonExample(),
        // home:  IncidentReportScreen(),
    );
  }
}
