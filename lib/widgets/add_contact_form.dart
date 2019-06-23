

import 'package:flutter/material.dart';
import 'package:pay_track/widgets/contact_form_field.dart';
import 'package:rxdart/rxdart.dart';

class AddContactForm extends StatefulWidget {

  @override
  AddContactFormState createState() => AddContactFormState();
}

class AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  String firstName, lastName, description, street, street2, city,
    state, zip, notes;

  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /// FIRST NAME
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a first name.';
                    }
                    firstName = value;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              /// LAST NAME
              ContactFormField(
                label: 'Last Name',
                textInputAction: TextInputAction.next,
                validationMessage: 'Please enter a last name.',
                valueSubject: BehaviorSubject<String>()..listen((val) {
                  print('New value!');
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}