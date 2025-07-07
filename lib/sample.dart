import 'package:flutter/material.dart';

class name extends StatelessWidget {
  const name({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(),
            TextField(),
            Spacer(),
            ElevatedButton(onPressed: (){}, child: Text('Send'))
          ],
        ),
      ));
  }
}