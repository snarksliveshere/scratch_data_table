import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController controller;
  String placeholder;
  CustomTextFormField(this.controller, this.placeholder);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      decoration: InputDecoration(
        hintText: this.placeholder,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.greenAccent,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue
          )
        ),
        contentPadding: EdgeInsets.all(8.0)
      ),
    );
  }
}