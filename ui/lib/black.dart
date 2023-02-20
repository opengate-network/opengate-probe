import 'package:flutter/material.dart';

class BlackPage extends StatelessWidget {
  const BlackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.black,
        ),
      ),
    );
  }
}
