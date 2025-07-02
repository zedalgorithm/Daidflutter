import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? selectedGender;
  DateTime? selectedDate;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? selectedAddress;

  final _formKey = GlobalKey<FormState>();

  File? _selfieImage;
  File? _validIdImage;

  String? _validateEmailAddress(String? email){
    RegExp emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
      if (email == null || email.isEmpty) {
        return 'Please enter an email address';
      }
      if (!isEmailValid){
        return 'Please enter a valid email';
      }
      return null;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _captureSelfie() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (photo != null) {
      setState(() {
        _selfieImage = File(photo.path);
      });
    }
  }

  Future<void> _captureValidIdImage() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _validIdImage = File(photo.path);
      });
    }
  }

  Widget _buildImageDisplay(File? image, String label, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text('Tap to capture $label', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  bool _validateForm() {
    if (fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return false;
    }
    if (religionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your religion')),
      );
      return false;
    }
    if (birthDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birth date')),
      );
      return false;
    }
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your address')),
      );
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return false;
    }
    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a password')),
      );
      return false;
    }
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return false;
    }
    if (_selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture your selfie')),
      );
      return false;
    }
    if (_validIdImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture your valid ID')),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    religionController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Create Account',
        style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (name) => name!.isEmpty ? 'Please enter your fullname' : name!.length < 5 ? 'Fullname should be more than 5 characters': null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.grey),
                        ),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                          errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                          focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField2<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (gender) {
                      if (gender == null || gender.isEmpty) {
                        return 'Please select a gender';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    hint: const Text('Select Gender'),
                    value: selectedGender,
                    items: ['Male', 'Female', 'Other']
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),

                  const SizedBox(height: 10),
                  TextFormField(
                    controller: religionController,
                    validator: (religion) => religion!.isEmpty ? 'Enter your religion' : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Religion',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: birthDateController,
                    readOnly: true,
                    validator: (birthdate) => birthdate!.isEmpty ? 'Please select your birthdate' : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      labelText: 'Birth Date',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
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
                  DropdownButtonFormField2<String>(
                    isDense: true,
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    alignment: AlignmentDirectional.centerStart,
                    isExpanded: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (address){
                      if (address == null || address.isEmpty) {
                        return 'Please select your address';
                      }
                      return null;                   
                    },
                    decoration: const InputDecoration(
                      labelText: 'Select Home Address',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    hint: const Text('Select Home Address'),
                    value: selectedAddress,
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
                    }, // ✅ Now works!
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateEmailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),                        
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (phNum) => phNum!.length < 10 ? 'Invalid phone number.\nMake sure it should be 10 characters long' : null,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+63 ',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),  
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => password!.length < 6 ? 'Password must be more than 6 characters long.' : null,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),  
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
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
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (confirmPassword) {
                        if (confirmPassword == null || confirmPassword.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (confirmPassword != passwordController.text) {
                          return 'Password did not match';
                        }
                        return null;
                      },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),  
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                        
                  // Selfie Capture Section
                  _buildImageDisplay(_selfieImage, 'Selfie (Face Photo)', _captureSelfie),
                  const SizedBox(height: 20),
                        
                  // Valid ID Capture Section
                  _buildImageDisplay(_validIdImage, 'Valid ID', _captureValidIdImage),
                  const SizedBox(height: 20),
                        
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // if (!_validateForm()) {
                          //   return;
                          // }
                              if (_formKey.currentState?.validate() == true) {
                                 try {
                                    // Show loading indicator
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => const Center(child: CircularProgressIndicator()),
                                    );
                                        
                                    // 1. Upload images to Firebase Storage
                                    final storage = FirebaseStorage.instance;
                                    final selfieRef = storage.ref('need_approval_selfies/${DateTime.now().millisecondsSinceEpoch}_${emailController.text.trim()}.jpg');
                                    final idRef = storage.ref('need_approval_ids/${DateTime.now().millisecondsSinceEpoch}_${emailController.text.trim()}.jpg');
                                        
                                    final selfieUploadTask = await selfieRef.putFile(_selfieImage!);
                                    final idUploadTask = await idRef.putFile(_validIdImage!);
                                        
                                    final selfieUrl = await selfieUploadTask.ref.getDownloadURL();
                                    final idUrl = await idUploadTask.ref.getDownloadURL();
                                        
                                    // 2. Save data to NeedApproval collection (NOT creating user in Auth yet)
                                    await FirebaseFirestore.instance.collection('NeedApproval').add({
                                      'name': fullNameController.text.trim(),
                                      'gender': selectedGender,
                                      'religion': religionController.text.trim(),
                                      'dateOfBirth': birthDateController.text,
                                      'address': selectedAddress,
                                      'email': emailController.text.trim(),
                                      'phoneNumber': '+63${phoneController.text.trim()}',
                                      'password': passwordController.text, // Store password for admin approval
                                      'selfieUrl': selfieUrl,
                                      'validIdUrl': idUrl,
                                      'timestamp': FieldValue.serverTimestamp(),
                                      'status': 'pending',
                                    });
                                        
                                    Navigator.of(context).pop(); // Remove loading indicator
                                        
                                    // Show thank you page
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) => const ThankYouScreen()),
                                    );
                                  } catch (e) {
                                    Navigator.of(context).pop(); // Remove loading indicator
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to submit: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                              }else{
                                _validateForm();
                              }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Submit for Approval', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Thank you for signing up!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your registration has been submitted for approval. '
                'You will receive an email once your account is approved by an administrator.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('LoginScreen');
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
