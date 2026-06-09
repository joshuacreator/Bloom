import 'package:flutter/material.dart';

class LecturesScreen extends StatelessWidget {
  static String id = 'lectures';

  const LecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lectures')),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: const [],
      ),
    );
  }
}
