import 'package:flutter/material.dart';
import 'package:reminders_app/widgets/colors.dart';

class buildInputField extends StatefulWidget {
  final String hintText;
  final TextInputType InputType;
  final bool isPassword;
  final TextEditingController CurrentController;

  const buildInputField(
      {super.key,
      required this.hintText,
      required this.InputType,
      required this.isPassword,
      required this.CurrentController});

  @override
  State<buildInputField> createState() => _buildInputFieldState();
}

class _buildInputFieldState extends State<buildInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: TextField(
        controller: widget.CurrentController,
        keyboardType: widget.InputType,
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inputBorder, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: inputBorder, width: 1),
            borderRadius: BorderRadius.circular(30),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 20,
            // color: Colors.black,
          ),
        ),
      ),
    );
  }
}
