import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final Function(String?) onSaved;

  const FormInputField({
    super.key,
    required this.label,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onSaved: onSaved,
    );
  }
}
