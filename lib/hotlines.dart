import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HotlinesScreen extends StatefulWidget {
  @override
  _HotlinesScreenState createState() => _HotlinesScreenState();
}

class _HotlinesScreenState extends State<HotlinesScreen> {
  final CollectionReference hotlines =
      FirebaseFirestore.instance.collection('Hotlines');

  bool modalVisible = false;
  String? editId;
  Map<String, String> newHotline = {'name': '', 'number': '', 'provider': ''};

  void _openModal([Map<String, dynamic>? data]) {
    if (data != null) {
      editId = data['id'];
      newHotline = {
        'name': data['name'],
        'number': data['number'],
        'provider': data['provider']
      };
    } else {
      editId = null;
      newHotline = {'name': '', 'number': '', 'provider': ''};
    }

    setState(() => modalVisible = true);
  }

  Future<void> _saveHotline() async {
    if (newHotline.values.any((element) => element.isEmpty)) return;

    try {
      if (editId != null) {
        await hotlines.doc(editId).update(newHotline);
      } else {
        await hotlines.add(newHotline);
      }

      setState(() {
        modalVisible = false;
        newHotline = {'name': '', 'number': '', 'provider': ''};
      });
    } catch (e) {
      print("Save error: $e");
    }
  }

  Future<void> _deleteHotline(String id) async {
    await hotlines.doc(id).delete();
  }

  Future<void> _callNumber(String number) async {
    String cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleaned.startsWith('+')) cleaned = '+63${cleaned.replaceFirst('0', '')}';

    final uri = Uri.parse('tel:$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Cannot launch phone call');
    }
  }

  Widget _buildHotlineItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        onTap: () => _openModal({'id': doc.id, ...data}),
        title: Text(
          '${data['name']} (${data['provider']})',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(data['number'], style: TextStyle(color: Colors.white)),
        trailing: IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: () => _callNumber(data['number']),
        ),
      ),
    );
  }

  Widget _buildModal() {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        editId != null ? 'Edit Hotline' : 'Add Hotline',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: ['name', 'number', 'provider'].map((field) {
            return TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: field[0].toUpperCase() + field.substring(1),
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
              ),
              keyboardType: field == 'number' ? TextInputType.phone : TextInputType.text,
              onChanged: (val) => newHotline[field] = val,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: newHotline[field]!,
                  selection: TextSelection.collapsed(offset: newHotline[field]!.length),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        if (editId != null)
          TextButton(
            onPressed: () {
              _deleteHotline(editId!);
              setState(() => modalVisible = false);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: _saveHotline,
          child: Text(editId != null ? "Update" : "Add", style: TextStyle(color: Colors.green)),
        ),
        TextButton(
          onPressed: () => setState(() => modalVisible = false),
          child: Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F0F7),
      appBar: AppBar(
        title: Text('Hotlines'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: hotlines.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) => _buildHotlineItem(doc)).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _openModal(),
        child: Icon(Icons.add),
      ),
      persistentFooterButtons: modalVisible ? [_buildModal()] : [],
    );
  }
}
