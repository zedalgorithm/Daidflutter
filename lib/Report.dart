


// import 'package:flutter/material.dart';
// import 'package:signature/signature.dart';


// class IncidentReportScreen extends StatefulWidget {
//   @override
//   _IncidentReportScreenState createState() => _IncidentReportScreenState();
// }

// class _IncidentReportScreenState extends State<IncidentReportScreen> {
//   List<bool> _checkBoxValues = List.generate(22, (index) => false);
//   String? witnessName;
//   String? patientName;
//   bool _isVehicularAccidentSelected = false;
//   String? _selectedCondition;
//   String? _selectedCause;
//   String? _selectedIncidentType;
//   bool _isMedicalCaseSelected = false;
//   bool _isTraumaCaseSelected = false;
//   String? _selectedSymptom;
//   String? _selectedTrauma;
//   List<String> _selectedSymptoms = []; // Track selected symptoms
//   List<String> _selectedTraumaOptions = []; // Track selected trauma options
//   List<String> _selectedConditions = []; // Track selected conditions
//   List<String> _selectedCauses = []; // Track selected causes
//   bool _waiverChecked1 = false;
//   bool _waiverChecked2 = false;
//   SignatureController _signatureController = SignatureController(
//     penStrokeWidth: 5,
//     penColor: Colors.black,
//   );
//   SignatureController _patientSignatureController = SignatureController(
//     penStrokeWidth: 5,
//     penColor: Colors.black,
//   );
//   String? _selectedMobilityOption; // Track selected mobility option
//   String? _selectedBurnOption; // Track selected burn option
//   String? selectedConsciousnessOption; // Track selected consciousness option

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Incident Report'),
//         backgroundColor: Colors.red,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(8.0),
                  
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Patient Details', style: TextStyle(color: Colors.white, fontSize: 20)),
//                 ),
//               ),
//               SizedBox(height: 10),
//               _buildTextField('Name', ''),
//               _buildTextField('Date', ''),
//               _buildTextField('Gender', ''),
//               _buildTextField('Age', ''),
//               _buildTextField('Contact Number', ''),
//               _buildTextField('Address', ''),
//               _buildTextField('Location', ''),
//               _buildTextField('Time', ''),
//               _buildTextField('Incident Time', ''),
//               _buildTextField('Informant', ''),
//               _buildTextField('Chief Complaint', ''),

//               SizedBox(height: 20),
//                            Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Type of Incident', style: TextStyle(color: Colors.white, fontSize: 20)),
//                 ),
//               ),
//               SizedBox(height: 10), // Spacing below the title
//               Column(
//                 children: [
//                   _buildIncidentOption('Vehicular Accident'),
//                   SizedBox(height: 5),
//                   _buildIncidentOption('Medical Case'),
//                   SizedBox(height: 5),
//                   _buildIncidentOption('Trauma Case'),
//                   SizedBox(height: 5),
//                   _buildIncidentOption('Transport Only'),
//                 ],
//               ),

//               // Show additional options based on selection
//               if (_isMedicalCaseSelected) ...[
//                 SizedBox(height: 20),
//                 // Text('Medical Case Symptoms', style: TextStyle(color: Colors.black, fontSize: 20)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildSymptomCheckbox('Hypertension'),
//                         _buildSymptomCheckbox('Vomiting'),
//                         _buildSymptomCheckbox('DOB/Cough'),
//                         _buildSymptomCheckbox('Nose Bleed'),
//                         _buildSymptomCheckbox('Fainting/Dizziness'),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildSymptomCheckbox('LBM'),
//                         _buildSymptomCheckbox('Fever/Seizure'),
//                         _buildSymptomCheckbox('Chest Pain'),
//                         _buildSymptomCheckbox('Skin Allergy'),
//                         _buildSymptomCheckbox('Labor Pain'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],

//               if (_isTraumaCaseSelected) ...[
//                 SizedBox(height: 20),
//                 Text('Trauma Case Options', style: TextStyle(color: Colors.black, fontSize: 20)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildTraumaCheckbox('Alcohol Intox'),
//                         _buildTraumaCheckbox('Drug Intox'),
//                         _buildTraumaCheckbox('Drowning'),
//                         _buildTraumaCheckbox('Electrocution'),
//                         _buildTraumaCheckbox('Stab Wounds'),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildTraumaCheckbox('Mauling'),
//                         _buildTraumaCheckbox('Fall'),
//                         _buildTraumaCheckbox('Animal Bite'),
//                         _buildTraumaCheckbox('FBAO'),
//                         _buildTraumaCheckbox('Psychiatric'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],

//               // Show conditions and causes if Vehicular Accident is selected
//               if (_selectedIncidentType == 'Vehicular Accident') ...[
//                 SizedBox(height: 20),
//                 // Text('Conditions', style: TextStyle(color: Colors.black, fontSize: 20)),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildConditionCheckbox('Deformity'),
//                         _buildConditionCheckbox('Burn'),
//                         _buildConditionCheckbox('Contusion'),
//                         _buildConditionCheckbox('Tenderness'),
//                         _buildConditionCheckbox('Abrasion'),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildConditionCheckbox('Laceration'),
//                         _buildConditionCheckbox('Avulsion'),
//                         _buildConditionCheckbox('Swelling'),
//                         _buildConditionCheckbox('Puncture'),
//                         _buildConditionCheckbox('Fracture'),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Cause Of Vehicular Accident', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
//                 ),
//               ),
//               SizedBox(height: 15),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildCauseCheckbox('Reckless'),
//                         _buildCauseCheckbox('Animal Xing'),
//                         _buildCauseCheckbox('Slip & Slide'),
//                         _buildCauseCheckbox('S. Ped Xing'),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildCauseCheckbox('Collision'),
//                         _buildCauseCheckbox('Speeding'),
//                         _buildCauseCheckbox('Drunk Driving'),
//                         _buildCauseCheckbox('Distracted'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],

//               SizedBox(height: 20),
//                             Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Mobility', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
//                 ),
//               ),
//               SizedBox(height: 10), // Spacing below the title
//               Column(
//                 children: [
//                   _buildMobilityOption('None'),
//                   SizedBox(height: 5),
//                   _buildMobilityOption('Ambulatory'),
//                   SizedBox(height: 5),
//                   _buildMobilityOption('Non-Ambulatory'),
//                 ],
//               ),



//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(8.0),
                  
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Burn', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
//                 ),
//               ),
//               SizedBox(height: 10), // Spacing below the title
//               Column(
//                 children: [
//                   _buildBurnOption('None'),
//                   SizedBox(height: 5),
//                   _buildBurnOption('1st Degree'),
//                   SizedBox(height: 5),
//                   _buildBurnOption('2nd Degree'),
//                   SizedBox(height: 5),
//                   _buildBurnOption('3rd Degree'),
//                 ],
//               ),

//               SizedBox(height: 20),
//                 Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(8.0),
                  
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Vital Signs', style: TextStyle(color: Colors.white, fontSize: 20)),
//                 ),
//               ),
//                SizedBox(height: 10),
//               _buildTextField('Temperature', ''),
//               _buildTextField('Pulse Rate', ''),
//               _buildTextField('Respiratory Rate', ''),
//               _buildTextField('SpO2', ''),
//               _buildTextField('Blood Pressure', ''),


            
//                  SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   border: Border.all(color: Colors.black),
//                   borderRadius: BorderRadius.circular(8.0),
                  
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Level of Consciousness', style: TextStyle(color: Colors.white, fontSize: 20)),
//                 ),
//               ),

//                SizedBox(height: 10),
//               Column(
//                 children: [
//                   _buildConsciousnessOption('Alert'),
//                   SizedBox(height: 5),
//                   _buildConsciousnessOption('Verbal Response'),
//                   SizedBox(height: 5),
//                   _buildConsciousnessOption('Responsive to Pain'),
//                   SizedBox(height: 5),
//                   _buildConsciousnessOption('Unresponsive'),
//                 ],
//               ),

//               SizedBox(height: 20),
          
//                Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Action Taken', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
//                 ),
//               ),
//               SizedBox(height: 15),
//               _buildCheckboxGroup(),

//               // Waiver Section
//               SizedBox(height: 20),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black, // Set background color to black
//                   borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                 ),
//                 padding: EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text('Waiver', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
//                 ),
//               ),
//               SizedBox(height: 15),
//               Row(
//                 children: [
//                   Checkbox(
//                     value: _waiverChecked1, // Track the first waiver checkbox
//                     onChanged: (bool? newValue) {
//                       setState(() {
//                         _waiverChecked1 = newValue!;
//                       });
//                     },
//                     activeColor: Colors.black,
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Refuse any medical aid and/or evaluation by emergency medical personnel.',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Checkbox(
//                     value: _waiverChecked2, // Track the second waiver checkbox
//                     onChanged: (bool? newValue) {
//                       setState(() {
//                         _waiverChecked2 = newValue!;
//                       });
//                     },
//                     activeColor: Colors.black,
//                   ),
//                   Expanded(
//                     child: Text(
//                       'Refuse transport to emergency receiving facility by emergency medical personnel.',
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'I also acknowledge that I have been advised that medical aid is needed and that my refusal of evaluation and/or transportation may result in the worsening of my condition and could result in permanent injury or death. I will not hold anyone accountable for my decision.',
//                 style: TextStyle(color: Colors.black),
//               ),

//               // Signature Section
//               SizedBox(height: 20),
//               Text('Witness Name & Signature', style: TextStyle(color: Colors.black, fontSize: 20)),
//               GestureDetector(
//                 onLongPress: () {
//                   _signatureController.clear(); // Clear the signature pad on long press
//                 },
//                 child: Signature(
//                   controller: _signatureController,
//                   height: 150,
//                   backgroundColor: Colors.grey[200]!,
//                 ),
//               ),
//               SizedBox(height: 10),
             
//               _buildTextField('Witness Name', 'Enter Name'),
//               _buildTextField('Relation/Designation', 'Enter Relation/Designation'),

//               SizedBox(height: 20),
//               Text('Patient Name & Signature', style: TextStyle(color: Colors.black, fontSize: 20)),
//               GestureDetector(
//                 onLongPress: () {
//                   _patientSignatureController.clear(); // Clear the patient signature pad on long press
//                 },
//                 child: Signature(
//                   controller: _patientSignatureController,
//                   height: 150,
//                   backgroundColor: Colors.grey[200]!,
//                 ),
//               ),
//               SizedBox(height: 10),
//               _buildTextField('Patient Name', 'Enter Name'),
//               _buildTextField('Signature', 'Enter Signature'),

//               // Save Report Button
//               SizedBox(height: 15),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Save report functionality
//                   },
//                   child: Text(
//                     'Save Report',
//                     style: TextStyle(
//                       color: Colors.white, // Text color
//                       fontSize: 18, // Font size
//                       fontWeight: FontWeight.bold, // Bold text
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green, // Background color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0), // Rounded corners
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80), // Adjust padding for height
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, String placeholder) {
//     return Column(
//       children: [
//         SizedBox(height: 5),
//         TextField(
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: placeholder,
//             filled: true,
//             fillColor: Colors.grey[50],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide(color: Colors.black),
//             ),
//           ),
//           style: TextStyle(color: Colors.black),
//           cursorColor: Colors.black,
//           onChanged: (value) {
//             if (label == 'Witness Name') {
//               witnessName = value;
//             } else if (label == 'Patient Name') {
//               patientName = value;
//             }
//           },
//         ),
//         SizedBox(height: 1),
//       ],
//     );
//   }

//   Widget _buildDropdownField(String label, List<String> options) {
//     String? selectedValue;
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.grey[150],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: TextStyle(color: Colors.white),
//       dropdownColor: Colors.grey[150],
//       value: selectedValue,
//       items: options.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value, style: TextStyle(color: Colors.white)),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           selectedValue = newValue;
//         });
//       },
//     );
//   }

//   Widget _buildRadioGroup(String label, List<String> options) {
//     String? selectedValue;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: options.map((String value) {
//         return Row(
//           children: [
//             Radio<String>(
//               value: value,
//               groupValue: selectedValue,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedValue = newValue;
//                 });
//               },
//               activeColor: Colors.white,
//             ),
//             Text(value, style: TextStyle(color: Colors.black)),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildCheckboxGroup() {
//     List<String> options = [
//       'Oxygenation',
//       'Nebulization',
//       'HGT',
//       'Advice to eat',
//       'Assisted on meds',
//       'VS Check',
//       'Hydration',
//       'Advise BRAT',
//       'Restrained',
//       'Tourniquet',
//       'Bandaging',
//       'Cold Compress',
//       'Warm Compress',
//       'Burn Care',
//       'Wound Care',
//       'CPR',
//       'Rescue Breathing',
//       'FBAD Mgt.',
//       'AED',
//       'Arm Sling',
//       'Spinal Board',
//       'C.Color',
//       'Splinting',
//     ];

//     // Ensure _checkBoxValues is initialized to the same length as options
//     if (_checkBoxValues.length != options.length) {
//       _checkBoxValues = List.generate(options.length, (index) => false);
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: options.sublist(0, options.length ~/ 2).map((option) {
//             return _buildCheckbox(option, options);
//           }).toList(),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: options.sublist(options.length ~/ 2).map((option) {
//             return _buildCheckbox(option, options);
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildCheckbox(String title, List<String> options) {
//     return Row(
//       children: [
//         Checkbox(
//           value: _checkBoxValues[options.indexOf(title)],
//           onChanged: (bool? newValue) {
//             setState(() {
//               _checkBoxValues[options.indexOf(title)] = newValue!;
//             });
//           },
//           activeColor: Colors.black,
//         ),
//         Text(title, style: TextStyle(color: Colors.black)),
//       ],
//     );
//   }

//   Widget _buildConditionCheckbox(String title) {
//     return Row(
//       children: [
//         Checkbox(
//           value: _selectedConditions.contains(title),
//           onChanged: (bool? newValue) {
//             setState(() {
//               if (newValue == true) {
//                 _selectedConditions.add(title); // Add condition if checked
//               } else {
//                 _selectedConditions.remove(title); // Remove condition if unchecked
//               }
//             });
//           },
//           activeColor: Colors.black,
//         ),
//         Text(title, style: TextStyle(color: Colors.black)),
//       ],
//     );
//   }

//   Widget _buildCauseCheckbox(String title) {
//     return Row(
//       children: [
//         Checkbox(
//           value: _selectedCauses.contains(title),
//           onChanged: (bool? newValue) {
//             setState(() {
//               if (newValue == true) {
//                 _selectedCauses.add(title); // Add cause if checked
//               } else {
//                 _selectedCauses.remove(title); // Remove cause if unchecked
//               }
//             });
//           },
//           activeColor: Colors.black,
//         ),
//         Text(title, style: TextStyle(color: Colors.black)),
//       ],
//     );
//   }

//   Widget _buildIncidentOption(String title) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIncidentType = title;
//           _isMedicalCaseSelected = title == 'Medical Case';
//           _isTraumaCaseSelected = title == 'Trauma Case';
//           _isVehicularAccidentSelected = title == 'Vehicular Accident';
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(0.1),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(8.0),
//           color: _selectedIncidentType == title ? Colors.red : Colors.white,
//         ),
//         child: ListTile(
//           title: Text(title, style: TextStyle(color: Colors.black)),
//         ),
//       ),
//     );
//   }

//   Widget _buildSymptomCheckbox(String title) {
//     return Row(
//       children: [
//         Checkbox(
//           value: _selectedSymptoms.contains(title),
//           onChanged: (bool? newValue) {
//             setState(() {
//               if (newValue == true) {
//                 _selectedSymptoms.add(title); // Add symptom if checked
//               } else {
//                 _selectedSymptoms.remove(title); // Remove symptom if unchecked
//               }
//             });
//           },
//           activeColor: Colors.black,
//         ),
//         Text(title, style: TextStyle(color: Colors.black)),
//       ],
//     );
//   }

//   Widget _buildTraumaCheckbox(String title) {
//     return Row(
//       children: [
//         Checkbox(
//           value: _selectedTraumaOptions.contains(title),
//           onChanged: (bool? newValue) {
//             setState(() {
//               if (newValue == true) {
//                 _selectedTraumaOptions.add(title); // Add trauma option if checked
//               } else {
//                 _selectedTraumaOptions.remove(title); // Remove trauma option if unchecked
//               }
//             });
//           },
//           activeColor: Colors.black,
//         ),
//         Text(title, style: TextStyle(color: Colors.black)),
//       ],
//     );
//   }

//   Widget _buildMobilityOption(String title) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           // Update the selected mobility option
//           _selectedMobilityOption = title; // Add this variable to track the selected option
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(0.1),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(8.0),
//           color: _selectedMobilityOption == title ? Colors.red : Colors.white, // Change color based on selection
//         ),
//         child: ListTile(
//           title: Text(title, style: TextStyle(color: Colors.black)),
//         ),
//       ),
//     );
//   }

//   Widget _buildBurnOption(String title) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           // Update the selected burn option
//           _selectedBurnOption = title; // Track the selected option
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(0.1),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(8.0),
//           color: _selectedBurnOption == title ? Colors.red : Colors.white, // Change color based on selection
//         ),
//         child: ListTile(
//           title: Text(title, style: TextStyle(color: Colors.black)),
//         ),
//       ),
//     );
//   }

//   Widget _buildConsciousnessOption(String title) {
//     return GestureDetector(
//       onTap: () {
//         // Update the selected consciousness option
//         setState(() {
//           selectedConsciousnessOption = title;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(0.1),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(8.0),
//           color: selectedConsciousnessOption == title ? Colors.red : Colors.white, // Change color based on selection
//         ),
//         child: ListTile(
//           title: Text(title, style: TextStyle(color: Colors.black)),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:typed_data';

class IncidentReportScreen extends StatefulWidget {
  @override
  _IncidentReportScreenState createState() => _IncidentReportScreenState();
  final String documentId;
  IncidentReportScreen({Key? key, required this.documentId}) : super(key: key);
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  List<bool> _checkBoxValues = List.generate(22, (index) => false);
  String? witnessName;
  String? patientName;
  bool _isVehicularAccidentSelected = false;
  String? _selectedCondition;
  String? _selectedCause;
  String? _selectedIncidentType;
  bool _isMedicalCaseSelected = false;
  bool _isTraumaCaseSelected = false;
  String? _selectedSymptom;
  String? _selectedTrauma;
  List<String> _selectedSymptoms = []; // Track selected symptoms
  List<String> _selectedTraumaOptions = []; // Track selected trauma options
  List<String> _selectedConditions = []; // Track selected conditions
  List<String> _selectedCauses = []; // Track selected causes
  bool _waiverChecked1 = false;
  bool _waiverChecked2 = false;
  SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
  );
  SignatureController _patientSignatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
  );
  String? _selectedMobilityOption; // Track selected mobility option
  String? _selectedBurnOption; // Track selected burn option
  String? selectedConsciousnessOption; // Track selected consciousness option

  // Initialize userDetails to an empty map to avoid null errors
  Map<String, dynamic> userDetails = {};

  // Declare controllers at the class level
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _incidentTimeController = TextEditingController();
  TextEditingController _informantController = TextEditingController();
  TextEditingController _chiefComplaintController = TextEditingController();
  // Add controllers for vital signs
  TextEditingController _temperatureController = TextEditingController();
  TextEditingController _pulseRateController = TextEditingController();
  TextEditingController _respiratoryRateController = TextEditingController();
  TextEditingController _spo2Controller = TextEditingController();
  TextEditingController _bloodPressureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.documentId.isNotEmpty) {
      _fetchData(widget.documentId); // Fetch data using the documentId passed to the widget
    } else {
      // Handle the case where documentId is not passed
      print('Error: documentId is not provided.');
      // Optionally, you can show an error message or navigate back
    }
  }

  void _fetchData(String documentId) async {
    // Fetch data from the Help Requests collection using the documentId
    var document = await FirebaseFirestore.instance.collection('Help Requests').doc(documentId).get();
    print(documentId);
    if (document.exists) {
      var data = document.data() as Map<String, dynamic>; // Populate userDetails with fetched data
      var userDetails = data['userDetails'] as Map<String, dynamic>;
      print(data);
      setState(() {
        this.userDetails = userDetails; 
        _nameController.text = userDetails['name'] ?? '';
        _dateController.text = data['requestDate'] ?? '';
        _genderController.text = userDetails['gender'] ?? '';
        _ageController.text = userDetails['age']?.toString() ?? ''; // Convert age to string
        _contactNumberController.text = userDetails['phoneNumber']?.toString() ?? ''; // Convert phone number to string
        _addressController.text = userDetails['address'] ?? '';
        double latitude = data['latitude'] ?? 0.0; // Replace with the correct key for latitude
        double longitude = data['longitude'] ?? 0.0; // Replace with the correct key for longitude
        _locationController.text = '$latitude, $longitude'; // Combine latitude and longitude
        _timeController.text = DateFormat('hh:mm:ss').format(DateTime.now()); // Get current time.
        _incidentTimeController.text = data['timeNow'] ?? ''; // Assuming 'incidentTime' is the correct key
        _informantController.text = userDetails[''] ?? ''; // Assuming 'informant' is the correct key
        _chiefComplaintController.text = userDetails['chiefComplaint'] ?? ''; // Assuming 'chiefComplaint' is the correct key

        if (data['accidentType'] == 'Vehicular Accident') {
          _selectedIncidentType = 'Vehicular Accident';
          _isVehicularAccidentSelected = true;
        }
        if (data['accidentType'] == 'Medical Case') {
          _selectedIncidentType = 'Medical Case';
          _isMedicalCaseSelected = true;
        }
        if (data['accidentType'] == 'Trauma Case') {
          _selectedIncidentType = 'Trauma Case';
          _isTraumaCaseSelected = true;
        } 
        // if (data['accidentType'] == 'Transport Only') {
        // _selectedIncidentType = 'Transport Only';
        // _isTransportOnlySelected = true;
        // } 
      }); // Call setState to update the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Report'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Patient Details / Person Who Reported', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              SizedBox(height: 10),
              
              _buildTextFieldq('Name', _nameController),
              _buildTextFieldq('Date', _dateController),
              _buildTextFieldq('Gender', _genderController),
              _buildTextFieldq('Age', _ageController),
              _buildTextFieldq('Contact Number', _contactNumberController),
              _buildTextFieldq('Address', _addressController),
              _buildTextFieldq('Location', _locationController),
              _buildTextFieldq('Time', _timeController),
              _buildTextFieldq('Incident Time', _incidentTimeController),
              _buildTextFieldq('Informant', _informantController),
              _buildTextFieldq('Chief Complaint', _chiefComplaintController),

              SizedBox(height: 20),
                           Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Type of Incident', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
              SizedBox(height: 10), // Spacing below the title
              Column(
                children: [
                  _buildIncidentOption('Vehicular Accident'),
                  SizedBox(height: 5),
                  _buildIncidentOption('Medical Case'),
                  SizedBox(height: 5),
                  _buildIncidentOption('Trauma Case'),
                  SizedBox(height: 5),
                  _buildIncidentOption('Transport Only'),
                ],
              ),

              // Show additional options based on selection
              if (_isMedicalCaseSelected) ...[
                SizedBox(height: 20),
                // Text('Medical Case Symptoms', style: TextStyle(color: Colors.black, fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSymptomCheckbox('Hypertension'),
                        _buildSymptomCheckbox('Vomiting'),
                        _buildSymptomCheckbox('DOB/Cough'),
                        _buildSymptomCheckbox('Nose Bleed'),
                        _buildSymptomCheckbox('Fainting/Dizziness'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSymptomCheckbox('LBM'),
                        _buildSymptomCheckbox('Fever/Seizure'),
                        _buildSymptomCheckbox('Chest Pain'),
                        _buildSymptomCheckbox('Skin Allergy'),
                        _buildSymptomCheckbox('Labor Pain'),
                      ],
                    ),
                  ],
                ),
              ],

              if (_isTraumaCaseSelected) ...[
                SizedBox(height: 20),
                Text('Trauma Case Options', style: TextStyle(color: Colors.black, fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTraumaCheckbox('Alcohol Intox'),
                        _buildTraumaCheckbox('Drug Intox'),
                        _buildTraumaCheckbox('Drowning'),
                        _buildTraumaCheckbox('Electrocution'),
                        _buildTraumaCheckbox('Stab Wounds'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTraumaCheckbox('Mauling'),
                        _buildTraumaCheckbox('Fall'),
                        _buildTraumaCheckbox('Animal Bite'),
                        _buildTraumaCheckbox('FBAO'),
                        _buildTraumaCheckbox('Psychiatric'),
                      ],
                    ),
                  ],
                ),
              ],

          
              if (_selectedIncidentType == 'Vehicular Accident') ...[
                SizedBox(height: 20),
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildConditionCheckbox('Deformity'),
                        _buildConditionCheckbox('Burn'),
                        _buildConditionCheckbox('Contusion'),
                        _buildConditionCheckbox('Tenderness'),
                        _buildConditionCheckbox('Abrasion'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildConditionCheckbox('Laceration'),
                        _buildConditionCheckbox('Avulsion'),
                        _buildConditionCheckbox('Swelling'),
                        _buildConditionCheckbox('Puncture'),
                        _buildConditionCheckbox('Fracture'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
               Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Cause Of Vehicular Accident', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
                ),
              ),
              SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCauseCheckbox('Reckless'),
                        _buildCauseCheckbox('Animal Xing'),
                        _buildCauseCheckbox('Slip & Slide'),
                        _buildCauseCheckbox('S. Ped Xing'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCauseCheckbox('Collision'),
                        _buildCauseCheckbox('Speeding'),
                        _buildCauseCheckbox('Drunk Driving'),
                        _buildCauseCheckbox('Distracted'),
                      ],
                    ),
                  ],
                ),
              ],

              SizedBox(height: 20),
                            Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Mobility', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
                ),
              ),
              SizedBox(height: 10), // Spacing below the title
              Column(
                children: [
                  _buildMobilityOption('None'),
                  SizedBox(height: 5),
                  _buildMobilityOption('Ambulatory'),
                  SizedBox(height: 5),
                  _buildMobilityOption('Non-Ambulatory'),
                ],
              ),



              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Burn', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
                ),
              ),
              SizedBox(height: 10), // Spacing below the title
              Column(
                children: [
                  _buildBurnOption('None'),
                  SizedBox(height: 5),
                  _buildBurnOption('1st Degree'),
                  SizedBox(height: 5),
                  _buildBurnOption('2nd Degree'),
                  SizedBox(height: 5),
                  _buildBurnOption('3rd Degree'),
                ],
              ),

              SizedBox(height: 20),
                Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Vital Signs', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
               SizedBox(height: 10),
              _buildTextFieldq('Temperature', _temperatureController),
              _buildTextFieldq('Pulse Rate', _pulseRateController),
              _buildTextFieldq('Respiratory Rate', _respiratoryRateController),
              _buildTextFieldq('SpO2', _spo2Controller),
              _buildTextFieldq('Blood Pressure', _bloodPressureController),


            
                 SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                  
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Level of Consciousness', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),

               SizedBox(height: 10),
              Column(
                children: [
                  _buildConsciousnessOption('Alert'),
                  SizedBox(height: 5),
                  _buildConsciousnessOption('Verbal Response'),
                  SizedBox(height: 5),
                  _buildConsciousnessOption('Responsive to Pain'),
                  SizedBox(height: 5),
                  _buildConsciousnessOption('Unresponsive'),
                ],
              ),

              SizedBox(height: 20),
          
               Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Action Taken', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
                ),
              ),
              SizedBox(height: 15),
              _buildCheckboxGroup(),

              // Waiver Section
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black, // Set background color to black
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Waiver', style: TextStyle(color: Colors.white, fontSize: 20)), // Set text color to white
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    value: _waiverChecked1, // Track the first waiver checkbox
                    onChanged: (bool? newValue) {
                      setState(() {
                        _waiverChecked1 = newValue!;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  Expanded(
                    child: Text(
                      'Refuse any medical aid and/or evaluation by emergency medical personnel.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _waiverChecked2, // Track the second waiver checkbox
                    onChanged: (bool? newValue) {
                      setState(() {
                        _waiverChecked2 = newValue!;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  Expanded(
                    child: Text(
                      'Refuse transport to emergency receiving facility by emergency medical personnel.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'I also acknowledge that I have been advised that medical aid is needed and that my refusal of evaluation and/or transportation may result in the worsening of my condition and could result in permanent injury or death. I will not hold anyone accountable for my decision.',
                style: TextStyle(color: Colors.black),
              ),

              // Signature Section
              SizedBox(height: 20),
              Text('Witness Name & Signature', style: TextStyle(color: Colors.black, fontSize: 20)),
              GestureDetector(
                onLongPress: () {
                  _signatureController.clear(); // Clear the signature pad on long press
                },
                child: Signature(
                  controller: _signatureController,
                  height: 150,
                  backgroundColor: Colors.grey[200]!,
                ),
              ),
              SizedBox(height: 10),
             
              _buildTextField('Witness Name', 'Enter Name'),
              _buildTextField('Relation/Designation', 'Enter Relation/Designation'),

              SizedBox(height: 20),
              Text('Patient Name & Signature', style: TextStyle(color: Colors.black, fontSize: 20)),
              GestureDetector(
                onLongPress: () {
                  _patientSignatureController.clear(); // Clear the patient signature pad on long press
                },
                child: Signature(
                  controller: _patientSignatureController,
                  height: 150,
                  backgroundColor: Colors.grey[200]!,
                ),
              ),
              SizedBox(height: 10),
              _buildTextField('Patient Name', 'Enter Name'),
              

              // Save Report Button
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Gather all data from the form
                    // Get signature data as PNG bytes and encode as base64
                    Uint8List? witnessSignatureBytes = await _signatureController.toPngBytes();
                    Uint8List? patientSignatureBytes = await _patientSignatureController.toPngBytes();
                    String? witnessSignatureBase64 = witnessSignatureBytes != null ? base64Encode(witnessSignatureBytes) : null;
                    String? patientSignatureBase64 = patientSignatureBytes != null ? base64Encode(patientSignatureBytes) : null;

                    // Map actions to actionX: actionName if checked
                    List<String> actionOptions = [
                      'Oxygenation',
                      'Nebulization',
                      'HGT',
                      'Advice to eat',
                      'Assisted on meds',
                      'VS Check',
                      'Hydration',
                      'Advise BRAT',
                      'Restrained',
                      'Tourniquet',
                      'Bandaging',
                      'Cold Compress',
                      'Warm Compress',
                      'Burn Care',
                      'Wound Care',
                      'CPR',
                      'Rescue Breathing',
                      'FBAD Mgt.',
                      'AED',
                      'Arm Sling',
                      'Spinal Board',
                      'C.Color',
                      'Splinting',
                    ];
                    Map<String, String> actionsMap = {};
                    for (int i = 0; i < _checkBoxValues.length && i < actionOptions.length; i++) {
                      if (_checkBoxValues[i]) {
                        actionsMap['action${i + 1}'] = actionOptions[i];
                      }
                    }

                    Map<String, dynamic> reportData = {
                      'name': _nameController.text,
                      'date': _dateController.text,
                      'gender': _genderController.text,
                      'age': _ageController.text,
                      'contactNumber': _contactNumberController.text,
                      'address': _addressController.text,
                      'location': _locationController.text,
                      'time': _timeController.text,
                      'incidentTime': _incidentTimeController.text,
                      'informant': _informantController.text,
                      'chiefComplaint': _chiefComplaintController.text,
                      'temperature': _temperatureController.text,
                      'pulseRate': _pulseRateController.text,
                      'respiratoryRate': _respiratoryRateController.text,
                      'spo2': _spo2Controller.text,
                      'bloodPressure': _bloodPressureController.text,
                      'incidentType': _selectedIncidentType,
                      'incidentMember': _selectedConditions,
                      'selectedCauses': _selectedCauses,
                      'selectedMobilityOption': _selectedMobilityOption,
                      'selectedBurnOption': _selectedBurnOption,
                      'selectedConsciousnessOption': selectedConsciousnessOption,
                      'waiverChecked1': _waiverChecked1,
                      'waiverChecked2': _waiverChecked2,
                      'witnessName': witnessName,
                      'patientName': patientName,
                      'action taken': actionsMap,
                      'witnessSignature': witnessSignatureBase64,
                      'patientSignature': patientSignatureBase64,
                      // Add more fields as needed
                    };
                    try {
                      await FirebaseFirestore.instance.collection('Responded Requests').doc(widget.documentId).set(reportData);
                      // Delete the original request from 'Help Requests' after saving
                      await FirebaseFirestore.instance.collection('Help Requests').doc(widget.documentId).delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report saved successfully!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving report: ' + e.toString())),
                      );
                    }
                  },
                  
                  child: Text(
                    'Save Report',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80), // Adjust padding for height
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return Column(
      children: [
        SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          onChanged: (value) {
            if (label == 'Witness Name') {
              witnessName = value;
            } else if (label == 'Patient Name') {
              patientName = value;
            }
          },
        ),
        SizedBox(height: 1),
      ],
    );
  }

  Widget _buildTextFieldq(String label, TextEditingController controller) {
    return Column(
      children: [
        SizedBox(height: 5),
        TextField(
          controller: controller, // Use the controller here
          decoration: InputDecoration(
            labelText: label,
            hintText: controller.text.isEmpty ? 'Enter $label' : '', // Change placeholder based on controller
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          onChanged: (value) {
            if (label == 'Witness Name') {
              witnessName = value;
            } else if (label == 'Patient Name') {
              patientName = value;
            }
          },
        ),
        SizedBox(height: 1),
      ],
    );
  }

  Widget _buildTextFields(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the label at the top
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5), // Space between label and text field
        TextField(
          controller: controller, // Use the controller here
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.purple, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.purple, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.purple, width: 2),
            ),
          ),
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.purple,
        ),
        SizedBox(height: 10), // Space below the text field
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    String? selectedValue;
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[150],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.grey[150],
      value: selectedValue,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
      },
    );
  }

  Widget _buildRadioGroup(String label, List<String> options) {
    String? selectedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((String value) {
        return Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
              activeColor: Colors.white,
            ),
            Text(value, style: TextStyle(color: Colors.black)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxGroup() {
    List<String> options = [
      'Oxygenation',
      'Nebulization',
      'HGT',
      'Advice to eat',
      'Assisted on meds',
      'VS Check',
      'Hydration',
      'Advise BRAT',
      'Restrained',
      'Tourniquet',
      'Bandaging',
      'Cold Compress',
      'Warm Compress',
      'Burn Care',
      'Wound Care',
      'CPR',
      'Rescue Breathing',
      'FBAD Mgt.',
      'AED',
      'Arm Sling',
      'Spinal Board',
      'C.Color',
      'Splinting',
    ];

    // Ensure _checkBoxValues is initialized to the same length as options
    if (_checkBoxValues.length != options.length) {
      _checkBoxValues = List.generate(options.length, (index) => false);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.sublist(0, options.length ~/ 2).map((option) {
            return _buildCheckbox(option, options);
          }).toList(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.sublist(options.length ~/ 2).map((option) {
            return _buildCheckbox(option, options);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, List<String> options) {
    return Row(
      children: [
        Checkbox(
          value: _checkBoxValues[options.indexOf(title)],
          onChanged: (bool? newValue) {
            setState(() {
              _checkBoxValues[options.indexOf(title)] = newValue!;
            });
          },
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildConditionCheckbox(String title) {
    return Row(
      children: [
        Checkbox(
          value: _selectedConditions.contains(title),
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue == true) {
                _selectedConditions.add(title); // Add condition if checked
              } else {
                _selectedConditions.remove(title); // Remove condition if unchecked
              }
            });
          },
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildCauseCheckbox(String title) {
    return Row(
      children: [
        Checkbox(
          value: _selectedCauses.contains(title),
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue == true) {
                _selectedCauses.add(title); // Add cause if checked
              } else {
                _selectedCauses.remove(title); // Remove cause if unchecked
              }
            });
          },
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildIncidentOption(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIncidentType = title;
          _isMedicalCaseSelected = title == 'Medical Case';
          _isTraumaCaseSelected = title == 'Trauma Case';
          _isVehicularAccidentSelected = title == 'Vehicular Accident';
        });
      },
      child: Container(
        padding: EdgeInsets.all(0.1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          color: _selectedIncidentType == title ? Colors.red : Colors.white,
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildSymptomCheckbox(String title) {
    return Row(
      children: [
        Checkbox(
          value: _selectedSymptoms.contains(title),
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue == true) {
                _selectedSymptoms.add(title); // Add symptom if checked
              } else {
                _selectedSymptoms.remove(title); // Remove symptom if unchecked
              }
            });
          },
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildTraumaCheckbox(String title) {
    return Row(
      children: [
        Checkbox(
          value: _selectedTraumaOptions.contains(title),
          onChanged: (bool? newValue) {
            setState(() {
              if (newValue == true) {
                _selectedTraumaOptions.add(title); // Add trauma option if checked
              } else {
                _selectedTraumaOptions.remove(title); // Remove trauma option if unchecked
              }
            });
          },
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildMobilityOption(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Update the selected mobility option
          _selectedMobilityOption = title; // Add this variable to track the selected option
        });
      },
      child: Container(
        padding: EdgeInsets.all(0.1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          color: _selectedMobilityOption == title ? Colors.red : Colors.white, // Change color based on selection
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildBurnOption(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Update the selected burn option
          _selectedBurnOption = title; // Track the selected option
        });
      },
      child: Container(
        padding: EdgeInsets.all(0.1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          color: _selectedBurnOption == title ? Colors.red : Colors.white, // Change color based on selection
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Widget _buildConsciousnessOption(String title) {
    return GestureDetector(
      onTap: () {
        // Update the selected consciousness option
        setState(() {
          selectedConsciousnessOption = title;
        });
      },
      child: Container(
        padding: EdgeInsets.all(0.1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          color: selectedConsciousnessOption == title ? Colors.red : Colors.white, // Change color based on selection
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
} 