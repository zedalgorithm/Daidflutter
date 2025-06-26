import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UHotlinesScreen extends StatefulWidget {
  const UHotlinesScreen({Key? key}) : super(key: key);

  @override
  State<UHotlinesScreen> createState() => _UHotlinesScreenState();
}

class _UHotlinesScreenState extends State<UHotlinesScreen> {
  final CollectionReference hotlinesRef =
      FirebaseFirestore.instance.collection('Hotlines');

  @override
  void initState() {
    super.initState();
    // You can set the title via Navigator if using a shell route or AppBar in Scaffold
  }

  Future<void> _callNumber(String number) async {
    if (number.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No phone number provided')),
      );
      return;
    }

    String clean = number.replaceAll(RegExp(r'[^\d+]'), '');
    if (!clean.startsWith('+')) {
      clean = '+63${clean.replaceFirst(RegExp(r'^0'), '')}';
    }

    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot launch phone dialer')),
      );
    }
  }

  Widget _buildHotlineItem(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                // Implement onTap for modal edit if needed
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data['name']} (${data['provider']})',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data['number'],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _callNumber(data['number']),
            icon: Icon(Icons.phone, color: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F0F7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 247, 245, 245),
        title: Text('Emergency Hotlines'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: hotlinesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading hotlines'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final docData = data[index].data() as Map<String, dynamic>;
              return _buildHotlineItem(docData);
            },
          );
        },
      ),

      // Uncomment when enabling Add Hotline:
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show modal to add
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      */
    );
  }
}
