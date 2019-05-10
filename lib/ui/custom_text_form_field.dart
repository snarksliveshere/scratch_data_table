import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController controller;
  CustomTextFormField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      decoration: InputDecoration(
          fillColor: Colors.amberAccent.shade100,
          filled: true
      ),
    );
  }
}