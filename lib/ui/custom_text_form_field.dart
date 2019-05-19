import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController controller;
  String placeholder;
  String initialValue;
  CustomTextFormField(this.controller, this.placeholder);
//  CustomTextFormField(controller, placeholder, [initialValue]) {
//    this.controller = controller;
//    this.placeholder = placeholder;
//    this.initialValue = initialValue;
//    print(initialValue);
//    print(controller);
//  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      decoration: InputDecoration(
        hintText: this.placeholder,
        hintStyle: TextStyle(
          color: Theme.of(context).primaryColor,
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
        contentPadding: EdgeInsets.all(8.0)
      ),
    );
  }
}