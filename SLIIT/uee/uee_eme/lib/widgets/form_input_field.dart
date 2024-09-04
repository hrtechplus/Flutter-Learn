import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final Function(String?) onSaved;

  const FormInputField({
    Key? key,
    required this.label,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onSaved: onSaved,
    );
  }
}
