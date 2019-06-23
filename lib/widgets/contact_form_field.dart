import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ContactFormField extends StatelessWidget {
  final String label;
  final String validationMessage;
  final TextInputAction textInputAction;
  final BehaviorSubject<String> valueSubject;

  ContactFormField({
    @required this.label, 
    @required this.validationMessage, 
    @required this.textInputAction, 
    @required this.valueSubject
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return validationMessage;
          }
          valueSubject.add(value);
        },
        textInputAction: textInputAction,
      ),
    );
  }

}