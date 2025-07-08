import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class RespondedRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responded Requests'),
        backgroundColor: const Color.fromARGB(255, 247, 247, 248),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Responded Requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No responded requests found.'));
          }
          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: _getIncidentIcon(data['incidentType']),
                  title: Text(data['name'] ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: 	${data['date'] ?? 'N/A'}'),
                      Text('Incident Type: ${data['incidentType'] ?? 'N/A'}'),
                     
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RespondedRequestDetail(data: data),
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

  Widget _getIncidentIcon(String? incidentType) {
    switch (incidentType) {
      case 'Medical Case':
        return Icon(Icons.medical_services, color: Colors.redAccent, size: 32);
      case 'Fire':
        return Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 32);
      case 'Police':
        return Icon(Icons.local_police, color: Colors.blue, size: 32);
      case 'Vehicular Accident':
        return Icon(Icons.directions_car, color: const Color.fromARGB(255, 234, 4, 4), size: 32);
      default:
        return Icon(Icons.report, color: Colors.grey, size: 32);
    }
  }
}

class RespondedRequestDetail extends StatelessWidget {
  final Map<String, dynamic> data;
  RespondedRequestDetail({Key? key, required this.data}) : super(key: key);

  // Readonly text field
  Widget readonlyTextField(String label, String? value) {
    return Column(
      children: [
        SizedBox(height: 5),
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: label,
            hintText: value ?? '',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          style: TextStyle(color: Colors.black),
          controller: TextEditingController(text: value ?? ''),
        ),
        SizedBox(height: 1),
      ],
    );
  }

  // Readonly checkbox
  Widget readonlyCheckbox(String label, bool checked) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: checked,
          onChanged: null,
          activeColor: Colors.black,
          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: TextStyle(color: Colors.black),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  // Readonly option selector (for single select)
  Widget readonlyIncidentOption(String title, bool selected) {
    return Container(
      padding: EdgeInsets.all(0.1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: selected ? Colors.red : Colors.white,
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  // Readonly chips for multi-select
  Widget readonlyChips(String label, List<dynamic>? values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: values == null || values.isEmpty
                ? Text('N/A')
                : Wrap(
                    spacing: 6,
                    children: values.map((v) => Chip(label: Text(v.toString()))).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // Readonly radio group
  Widget readonlyRadioGroup(String label, List<String> options, String? selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ...options.map((option) => Row(
          children: [
            Radio<String>(
              value: option,
              groupValue: selected,
              onChanged: null,
              activeColor: Colors.black,
            ),
            Text(option, style: TextStyle(color: Colors.black)),
          ],
        )),
      ],
    );
  }

  // Readonly dropdown
  Widget readonlyDropdown(String label, String? value, List<String> options) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[150],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      items: options.map((String v) {
        return DropdownMenuItem<String>(
          value: v,
          child: Text(v, style: TextStyle(color: Colors.black)),
        );
      }).toList(),
      onChanged: null,
      disabledHint: Text(value ?? 'N/A'),
    );
  }

  Widget sectionHeader(String title) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8),
        margin: EdgeInsets.only(top: 18, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
      );

  // Helper lists for options (should match those in Report.dart)
  final List<String> incidentTypes = [
    'Vehicular Accident', 'Medical Case', 'Trauma Case', 'Transport Only'
  ];
  final List<String> mobilityOptions = [
    'None', 'Ambulatory', 'Non-Ambulatory'
  ];
  final List<String> burnOptions = [
    'None', '1st Degree', '2nd Degree', '3rd Degree'
  ];
  final List<String> consciousnessOptions = [
    'Alert', 'Verbal Response', 'Responsive to Pain', 'Unresponsive'
  ];
  final List<String> actionOptions = [
    'Oxygenation', 'Nebulization', 'HGT', 'Advice to eat', 'Assisted on meds', 'VS Check', 'Hydration', 'Advise BRAT', 'Restrained', 'Tourniquet', 'Bandaging', 'Cold Compress', 'Warm Compress', 'Burn Care', 'Wound Care', 'CPR', 'Rescue Breathing', 'FBAD Mgt.', 'AED', 'Arm Sling', 'Spinal Board', 'C.Color', 'Splinting'
  ];

  // Readonly symptom checkbox
  Widget readonlySymptomCheckbox(String title, List<dynamic>? selected) {
    return Row(
      children: [
        Checkbox(
          value: selected != null && selected.contains(title),
          onChanged: null,
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  final List<String> symptomOptionsCol1 = [
    'Hypertension', 'Vomiting', 'DOB/Cough', 'Nose Bleed', 'Fainting/Dizziness'
  ];
  final List<String> symptomOptionsCol2 = [
    'LBM', 'Fever/Seizure', 'Chest Pain', 'Skin Allergy', 'Labor Pain'
  ];

  // Readonly condition checkbox
  Widget readonlyConditionCheckbox(String title, List<dynamic>? selected) {
    return Row(
      children: [
        Checkbox(
          value: selected != null && selected.contains(title),
          onChanged: null,
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }
  final List<String> conditionOptionsCol1 = [
    'Deformity', 'Burn', 'Contusion', 'Tenderness', 'Abrasion'
  ];
  final List<String> conditionOptionsCol2 = [
    'Laceration', 'Avulsion', 'Swelling', 'Puncture', 'Fracture'
  ];

  // Readonly cause checkbox
  Widget readonlyCauseCheckbox(String title, List<dynamic>? selected) {
    return Row(
      children: [
        Checkbox(
          value: selected != null && selected.contains(title),
          onChanged: null,
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }
  final List<String> causeOptionsCol1 = [
    'Reckless', 'Animal Xing', 'Slip & Slide', 'S. Ped Xing'
  ];
  final List<String> causeOptionsCol2 = [
    'Collision', 'Speeding', 'Drunk Driving', 'Distracted'
  ];

  // Readonly action taken checkbox
  Widget readonlyActionCheckbox(String title, List<dynamic>? selected) {
    return Row(
      children: [
        Checkbox(
          value: selected != null && selected.contains(title),
          onChanged: null,
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }
  final List<String> actionOptionsCol1 = [
    'Oxygenation', 'Nebulization', 'HGT', 'Advice to eat', 'Assisted on meds', 'VS Check', 'Hydration', 'Advise BRAT', 'Restrained', 'Tourniquet', 'Bandaging'
  ];
  final List<String> actionOptionsCol2 = [
    'Cold Compress', 'Warm Compress', 'Burn Care', 'Wound Care', 'CPR', 'Rescue Breathing', 'FBAD Mgt.', 'AED', 'Arm Sling', 'Spinal Board', 'C.Color', 'Splinting'
  ];

  // Readonly trauma checkbox
  Widget readonlyTraumaCheckbox(String title, List<dynamic>? selected) {
    return Row(
      children: [
        Checkbox(
          value: selected != null && selected.contains(title),
          onChanged: null,
          activeColor: Colors.black,
        ),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }
  final List<String> traumaOptionsCol1 = [
    'Alcohol Intox', 'Drug Intox', 'Drowning', 'Electrocution', 'Stab Wounds'
  ];
  final List<String> traumaOptionsCol2 = [
    'Mauling', 'Fall', 'Animal Bite', 'FBAO', 'Psychiatric'
  ];

  @override
  Widget build(BuildContext context) {
    final String? incidentType = data['incidentType'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
        backgroundColor: const Color.fromARGB(255, 254, 254, 255),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          sectionHeader('Patient Details'),
          readonlyTextField('Name', data['name']),
          SizedBox(height: 10),
          readonlyTextField('Date', data['date']),
          SizedBox(height: 10),
          readonlyTextField('Gender', data['gender']),
          SizedBox(height: 10),
          readonlyTextField('Age', data['age']),
          SizedBox(height: 10),
          readonlyTextField('Contact Number', data['contactNumber']),
          SizedBox(height: 10),
          readonlyTextField('Address', data['address']),
          SizedBox(height: 10),
          readonlyTextField('Location', data['location']),
          SizedBox(height: 10),
          readonlyTextField('Time', data['time']),
          SizedBox(height: 10),
          readonlyTextField('Incident Time', data['incidentTime']),
          SizedBox(height: 10),
          readonlyTextField('Informant', data['informant']),
          SizedBox(height: 10),
          readonlyTextField('Chief Complaint', data['chiefComplaint']),

          sectionHeader('Type of Incident'),
          ...incidentTypes.map((type) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: readonlyIncidentOption(type, data['incidentType'] == type),
          )),

          if (incidentType == 'Medical Case') ...[
            SizedBox(height: 20),
            sectionHeader('Symptoms'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: symptomOptionsCol1.map((option) => readonlySymptomCheckbox(option, data['selectedSymptoms'])).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: symptomOptionsCol2.map((option) => readonlySymptomCheckbox(option, data['selectedSymptoms'])).toList(),
                  ),
                ),
              ],
            ),
          ],

          if (incidentType == 'Trauma Case') ...[
            SizedBox(height: 20),
            sectionHeader('Trauma'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: traumaOptionsCol1.map((option) => readonlyTraumaCheckbox(option, data['selectedTraumaOptions'])).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: traumaOptionsCol2.map((option) => readonlyTraumaCheckbox(option, data['selectedTraumaOptions'])).toList(),
                  ),
                ),
              ],
            ),
          ],

          if (incidentType == 'Vehicular Accident') ...[
            SizedBox(height: 20),
            sectionHeader('Conditions'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: conditionOptionsCol1.map((option) => readonlyConditionCheckbox(option, data['selectedConditions'])).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: conditionOptionsCol2.map((option) => readonlyConditionCheckbox(option, data['selectedConditions'])).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            sectionHeader('Cause Of Vehicular Accident'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: causeOptionsCol1.map((option) => readonlyCauseCheckbox(option, data['selectedCauses'])).toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: causeOptionsCol2.map((option) => readonlyCauseCheckbox(option, data['selectedCauses'])).toList(),
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 20),
          sectionHeader('Mobility'),
          ...mobilityOptions.map((option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: readonlyIncidentOption(option, data['selectedMobilityOption'] == option),
          )),

          SizedBox(height: 20),
          sectionHeader('Burn'),
          ...burnOptions.map((option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: readonlyIncidentOption(option, data['selectedBurnOption'] == option),
          )),

          SizedBox(height: 20),
          sectionHeader('Vital Signs'),
          readonlyTextField('Temperature', data['temperature']),
          SizedBox(height: 10),
          readonlyTextField('Pulse Rate', data['pulseRate']),
          SizedBox(height: 10),
          readonlyTextField('Respiratory Rate', data['respiratoryRate']),
          SizedBox(height: 10),
          readonlyTextField('SpO2', data['spo2']),
          SizedBox(height: 10),
          readonlyTextField('Blood Pressure', data['bloodPressure']),

          SizedBox(height: 20),
          sectionHeader('Level of Consciousness'),
          ...consciousnessOptions.map((option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: readonlyIncidentOption(option, data['selectedConsciousnessOption'] == option),
          )),

          SizedBox(height: 20),
          sectionHeader('Action Taken'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: actionOptionsCol1.map((option) => readonlyActionCheckbox(option, (data['action taken'] as Map?)?.values.toList())).toList(),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: actionOptionsCol2.map((option) => readonlyActionCheckbox(option, (data['action taken'] as Map?)?.values.toList())).toList(),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          sectionHeader('Waiver'),
          readonlyCheckbox('Refused medical aid/evaluation by emergency medical personnel.', data['waiverChecked1'] == true),
          SizedBox(height: 5),
          readonlyCheckbox('Refused transport to emergency facility.', data['waiverChecked2'] == true),

          SizedBox(height: 20),
          sectionHeader('Witness'),
          readonlyTextField('Witness Name', data['witnessName']),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Witness Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                (data['witnessSignature'] != null && data['witnessSignature'].toString().isNotEmpty)
                    ? Center(
                        child: Container(
                          height: 80,
                          width: 200,
                          color: Colors.grey[300],
                          child: Image.memory(
                            base64Decode(data['witnessSignature']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Text('No signature'),
              ],
            ),
          ),

          SizedBox(height: 20),
          sectionHeader('Patient'),
          readonlyTextField('Patient Name', data['patientName']),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Patient Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                (data['patientSignature'] != null && data['patientSignature'].toString().isNotEmpty)
                    ? Center(
                        child: Container(
                          height: 80,
                          width: 200,
                          color: Colors.grey[300],
                          child: Image.memory(
                            base64Decode(data['patientSignature']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Text('No signature'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}