import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          fillColor: Colors.amberAccent.shade100,
          filled: true
      ),
    );
  }
}