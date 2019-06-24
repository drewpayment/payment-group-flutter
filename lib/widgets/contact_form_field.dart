import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Creates a text form field for use on the create
/// contact page. 
/// 
/// Use either [validationMessage] OR [validator].
/// [valueSubject] is required if using [validationMessage].
/// [valueSubject] is a subject for output of updated value.
class ContactFormField extends StatelessWidget {
  final String label;
  final String validationMessage;
  final TextInputAction textInputAction;
  final String Function(String) validator;
  final bool isRequired;
  final FocusNode focus;
  final void Function(String) onFieldSubmitted;
  final TextEditingController controller;

  ContactFormField({
    @required this.label, 
    @required this.textInputAction, 
    @required this.isRequired,
    @required this.controller,
    this.focus,
    this.onFieldSubmitted,
    this.validationMessage, 
    this.validator
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: validator ?? (value) {
          if (isRequired) {
            if (value.isEmpty) {
              return validationMessage;
            }
          }
        },
        textInputAction: textInputAction,
        focusNode: focus,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }

}