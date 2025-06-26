// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
  
//   // Define the barangay options as a constant list
//   static const List<Map<String, String>> barangayOptions = [
//     {'label': 'Alang-alang, Borongan', 'value': 'Alang-alang'},
//     {'label': 'Amantacop, Borongan', 'value': 'Amantacop'},
//     {'label': 'Ando, Borongan', 'value': 'Ando'},
//     {'label': 'Balacdas, Borongan', 'value': 'Balacdas'},
//     {'label': 'Balud, Borongan', 'value': 'Balud'},
//     {'label': 'Banuyo, Borongan', 'value': 'Banuyo'},
//     {'label': 'Baras, Borongan', 'value': 'Baras'},
//     {'label': 'Bato, Borongan', 'value': 'Bato'},
//     {'label': 'Bayobay, Borongan', 'value': 'Bayobay'},
//     {'label': 'Benowangan, Borongan', 'value': 'Benowangan'},
//     {'label': 'Bugas, Borongan', 'value': 'Bugas'},
//     {'label': 'Cabalagnan, Borongan', 'value': 'Cabalagnan'},
//     {'label': 'Cabong, Borongan', 'value': 'Cabong'},
//     {'label': 'Cagbonga, Borongan', 'value': 'Cagbonga'},
//     {'label': 'Calico-an, Borongan', 'value': 'Calico-an'},
//     {'label': 'Calingatngan, Borongan', 'value': 'Calingatngan'},
//     {'label': 'Camada, Borongan', 'value': 'Camada'},
//     {'label': 'Campesao, Borongan', 'value': 'Campesao'},
//     {'label': 'Can-abong, Borongan', 'value': 'Can-abong'},
//     {'label': 'Can-aga, Borongan', 'value': 'Can-aga'},
//     {'label': 'Canjaway, Borongan', 'value': 'Canjaway'},
//     {'label': 'Canlaray, Borongan', 'value': 'Canlaray'},
//     {'label': 'Canyopay, Borongan', 'value': 'Canyopay'},
//     {'label': 'Divinubo, Borongan', 'value': 'Divinubo'},
//     {'label': 'Hebacong, Borongan', 'value': 'Hebacong'},
//     {'label': 'Hindang, Borongan', 'value': 'Hindang'},
//     {'label': 'Lalawigan, Borongan', 'value': 'Lalawigan'},
//     {'label': 'Libuton, Borongan', 'value': 'Libuton'},
//     {'label': 'Locso-on, Borongan', 'value': 'Locso-on'},
//     {'label': 'Maybacong, Borongan', 'value': 'Maybacong'},
//     {'label': 'Maypangdan, Borongan', 'value': 'Maypangdan'},
//     {'label': 'Pepelitan, Borongan', 'value': 'Pepelitan'},
//     {'label': 'Pinanag-an, Borongan', 'value': 'Pinanag-an'},
//     {'label': 'Punta Maria, Borongan', 'value': 'Punta Maria'},
//     {'label': 'Purok A, Borongan', 'value': 'Purok A'},
//     {'label': 'Purok B, Borongan', 'value': 'Purok B'},
//     {'label': 'Purok C, Borongan', 'value': 'Purok C'},
//     {'label': 'Purok D1, Borongan', 'value': 'Purok D1'},
//     {'label': 'Purok D2, Borongan', 'value': 'Purok D2'},
//     {'label': 'Purok E, Borongan', 'value': 'Purok E'},
//     {'label': 'Purok F, Borongan', 'value': 'Purok F'},
//     {'label': 'Purok G, Borongan', 'value': 'Purok G'},
//     {'label': 'Purok H, Borongan', 'value': 'Purok H'},
//     {'label': 'Sabang North, Borongan', 'value': 'Sabang North'},
//     {'label': 'Sabang South, Borongan', 'value': 'Sabang South'},
//     {'label': 'San Andres, Borongan', 'value': 'San Andres'},
//     {'label': 'San Gabriel, Borongan', 'value': 'San Gabriel'},
//     {'label': 'San Gregorio, Borongan', 'value': 'San Gregorio'},
//     {'label': 'San Jose, Borongan', 'value': 'San Jose'},
//     {'label': 'San Mateo, Borongan', 'value': 'San Mateo'},
//     {'label': 'San Pablo, Borongan', 'value': 'San Pablo'},
//     {'label': 'San Saturnino, Borongan', 'value': 'San Saturnino'},
//     {'label': 'Santa Fe, Borongan', 'value': 'Santa Fe'},
//     {'label': 'Siha, Borongan', 'value': 'Siha'},
//     {'label': 'Sohutan, Borongan', 'value': 'Sohutan'},
//     {'label': 'Songco, Borongan', 'value': 'Songco'},
//     {'label': 'Suribao, Borongan', 'value': 'Suribao'},
//     {'label': 'Surok, Borongan', 'value': 'Surok'},
//     {'label': 'Taboc, Borongan', 'value': 'Taboc'},
//     {'label': 'Tabunan, Borongan', 'value': 'Tabunan'},
//     {'label': 'Tamoso, Borongan', 'value': 'Tamoso'},
//   ];

//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController religionController = TextEditingController();
//   final TextEditingController birthDateController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   String selectedGender = 'Male';
//   DateTime? selectedDate;
//   bool _isPasswordVisible = false;
//   String? qrData;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//       ),
//       backgroundColor: Colors.grey.shade50,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Create Account',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: fullNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 value: selectedGender,
//                 decoration: InputDecoration(
//                   labelText: 'Select Gender',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: <String>['Male', 'Female', 'Other']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedGender = value ?? 'Male';
//                   });
//                 },
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: religionController,
//                 decoration: InputDecoration(
//                   labelText: 'Religion',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: birthDateController,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   labelText: 'Birth Date',
//                   border: OutlineInputBorder(),
//                   hintText: 'Select Date',
//                 ),
//                 onTap: () async {
//                   final DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate ?? DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );

//                   if (pickedDate != null && pickedDate != selectedDate) {
//                     setState(() {
//                       selectedDate = pickedDate;
//                       birthDateController.text =
//                           "${pickedDate.toLocal()}".split(' ')[0];
//                     });
//                   }
//                 },
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: 'Select Home Address',
//                   border: OutlineInputBorder(),
//                 ),
//                 items: barangayOptions.map<DropdownMenuItem<String>>((option) {
//                   return DropdownMenuItem<String>(
//                     value: option['value'],
//                     child: Text(option['label']!),
//                   );
//                 }).toList(),
//                 onChanged: (String? value) {},
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email Address',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   prefixText: '+63 ',
//                   border: OutlineInputBorder(),
//                 ),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     String data = '''
//                       Name: ${fullNameController.text}
//                       Gender: $selectedGender
//                       Religion: ${religionController.text}
//                       Birth Date: ${birthDateController.text}
//                       Address: ${barangayOptions.firstWhere((option) => option['value'] == 'selected_value', orElse: () => {'label': 'Unknown'})['label']}
//                       Email: ${emailController.text}
//                       Phone: ${phoneController.text}
//                     ''';

//                     setState(() {
//                       qrData = data;
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (qrData != null) ...[
//                 Center(
//                   child: QrImageView(
//                     data: qrData!,
//                     version: QrVersions.auto,
//                     size: 200.0,
//                     backgroundColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Define the barangay options as a constant list
   static const List<Map<String, String>> barangayOptions = [
  {'label': 'Alang-alang, Borongan City', 'value': 'Alang-alang, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Amantacop, Borongan City', 'value': 'Amantacop, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Ando, Borongan City', 'value': 'Ando, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Balacdas, Borongan City', 'value': 'Balacdas, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Balud, Borongan City', 'value': 'Balud, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Banuyo, Borongan City', 'value': 'Banuyo, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Baras, Borongan City', 'value': 'Baras, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Bato, Borongan City', 'value': 'Bato, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Bayobay, Borongan City', 'value': 'Bayobay, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Benowangan, Borongan City', 'value': 'Benowangan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Bugas, Borongan City', 'value': 'Bugas, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Cabalagnan, Borongan City', 'value': 'Cabalagnan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Cabong, Borongan City', 'value': 'Cabong, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Cagbonga, Borongan City', 'value': 'Cagbonga, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Calico-an, Borongan City', 'value': 'Calico-an, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Calingatngan, Borongan City', 'value': 'Calingatngan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Camada, Borongan City', 'value': 'Camada, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Campesao, Borongan City', 'value': 'Campesao, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Can-abong, Borongan City', 'value': 'Can-abong, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Can-aga, Borongan City', 'value': 'Can-aga, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Canjaway, Borongan City', 'value': 'Canjaway, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Canlaray, Borongan City', 'value': 'Canlaray, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Canyopay, Borongan City', 'value': 'Canyopay, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Divinubo, Borongan City', 'value': 'Divinubo, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Hebacong, Borongan City', 'value': 'Hebacong, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Hindang, Borongan City', 'value': 'Hindang, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Lalawigan, Borongan City', 'value': 'Lalawigan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Libuton, Borongan City', 'value': 'Libuton, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Locso-on, Borongan City', 'value': 'Locso-on, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Maybacong, Borongan City', 'value': 'Maybacong, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Maypangdan, Borongan City', 'value': 'Maypangdan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Pepelitan, Borongan City', 'value': 'Pepelitan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Pinanag-an, Borongan City', 'value': 'Pinanag-an, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Punta Maria, Borongan City', 'value': 'Punta Maria, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok A, Borongan City', 'value': 'Purok A, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok B, Borongan City', 'value': 'Purok B, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok C, Borongan City', 'value': 'Purok C, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok D1, Borongan City', 'value': 'Purok D1, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok D2, Borongan City', 'value': 'Purok D2, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok E, Borongan City', 'value': 'Purok E, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok F, Borongan City', 'value': 'Purok F, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok G, Borongan City', 'value': 'Purok G, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Purok H, Borongan City', 'value': 'Purok H, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Sabang North, Borongan City', 'value': 'Sabang North, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Sabang South, Borongan City', 'value': 'Sabang South, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Andres, Borongan City', 'value': 'San Andres, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Gabriel, Borongan City', 'value': 'San Gabriel, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Gregorio, Borongan City', 'value': 'San Gregorio, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Jose, Borongan City', 'value': 'San Jose, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Mateo, Borongan City', 'value': 'San Mateo, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Pablo, Borongan City', 'value': 'San Pablo, Borongan City, Eastern Samar, Philippines'},
  {'label': 'San Saturnino, Borongan City', 'value': 'San Saturnino, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Santa Fe, Borongan City', 'value': 'Santa Fe, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Siha, Borongan City', 'value': 'Siha, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Sohutan, Borongan City', 'value': 'Sohutan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Songco, Borongan City', 'value': 'Songco, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Suribao, Borongan City', 'value': 'Suribao, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Surok, Borongan City', 'value': 'Surok, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Taboc, Borongan City', 'value': 'Taboc, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Tabunan, Borongan City', 'value': 'Tabunan, Borongan City, Eastern Samar, Philippines'},
  {'label': 'Tamoso, Borongan City', 'value': 'Tamoso, Borongan City, Eastern Samar, Philippines'},
];


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGender = 'Male';
  DateTime? selectedDate;
  bool _isPasswordVisible = false;
  String? selectedAddress;

  void _showQrDialog(String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your QR Code'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
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
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(
                  labelText: 'Select Gender',
                  border: OutlineInputBorder(),
                ),
                items: <String>['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: religionController,
                decoration: InputDecoration(
                  labelText: 'Religion',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                  border: OutlineInputBorder(),
                  hintText: 'Select Date',
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      birthDateController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Home Address',
                  border: OutlineInputBorder(),
                ),
                items: barangayOptions.map<DropdownMenuItem<String>>((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(option['label']!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedAddress = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+63 ',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String data = '''
                      Name: ${fullNameController.text}
                      Gender: $selectedGender
                      Religion: ${religionController.text}
                      Birth Date: ${birthDateController.text}
                      Address: ${selectedAddress ?? 'Unknown'}
                      Email: ${emailController.text}
                      Phone: ${phoneController.text}
                    ''';

                    // Call the dialog to show QR code
                    _showQrDialog(data);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
