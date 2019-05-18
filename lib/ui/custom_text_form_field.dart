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
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14.0,
          fontStyle: FontStyle.italic,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
            width: 0.0,
            style: BorderStyle.none
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue
          )
        ),
        fillColor: Colors.greenAccent,
        contentPadding: EdgeInsets.all(8.0)
      ),
    );
  }
}