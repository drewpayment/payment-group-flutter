import 'package:flutter/material.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/bloc/user_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/utils/state_hash.dart';
import 'package:pay_track/widgets/contact_form_field.dart';

class AddContactForm extends StatefulWidget {
  final Knock contact;

  AddContactForm({this.contact});

  @override
  AddContactFormState createState() => AddContactFormState(contact: contact);
}

class AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  final Knock contact;
  String firstName, lastName, description, street, street2, city,
    state, zip, notes;

  bool isLoading = false;

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _streetFocus = FocusNode();
  final _street2Focus = FocusNode();
  final _cityFocus = FocusNode();
  final _zipFocus = FocusNode();
  final _notesFocus = FocusNode();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final streetController = TextEditingController();
  final street2Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final notesController = TextEditingController();

  AddContactFormState({this.contact});

  @override
  void initState() {
    _setExistingContact();
    super.initState();
  }
  
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // padding: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _getWidgets(),
          ),
        ),
      ),
    );
  }

  void _setExistingContact() {
    if (contact != null) {
      if (contact?.firstName != null)
        firstNameController.value = TextEditingValue(text: contact?.firstName);
      if (contact?.lastName != null)
        lastNameController.value = TextEditingValue(text: contact?.lastName);
      if (contact?.description != null)
        descriptionController.value = TextEditingValue(text: contact?.description);
      if (contact?.address != null) 
        streetController.value = TextEditingValue(text: contact?.address);
      if (contact?.addressCont != null)
        street2Controller.value = TextEditingValue(text: contact?.addressCont);
      if (contact?.city != null)
        cityController.value = TextEditingValue(text: contact?.city);
      if (contact?.zip != null)
        zipController.value = TextEditingValue(text: contact?.zip);
      if (contact?.note != null)
        notesController.value = TextEditingValue(text: contact?.note);
    }
  }

  List<Widget> _getWidgets() {
    var widgets = List<Widget>();

    widgets.addAll([
      /// FIRST NAME
      ContactFormField(
        label: 'First Name',
        textInputAction: TextInputAction.next,
        validationMessage: 'Please enter a name or description.',
        controller: firstNameController,
        isRequired: true,
        focus: _firstNameFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
        },
      ),
      /// LAST NAME
      ContactFormField(
        label: 'Last Name',
        textInputAction: TextInputAction.next,
        validationMessage: 'Please enter a name or description.',
        controller: lastNameController,
        isRequired: true,
        focus: _lastNameFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _lastNameFocus, _descriptionFocus);
        },
      ),
      /// DESCRIPTION
      ContactFormField(
        label: 'Description',
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (firstNameController.value.text.isEmpty
            && lastNameController.value.text.isEmpty
            && value.isEmpty
          ) {
            return 'Either name or description is required';
          }
        },
        isRequired: true,
        focus: _descriptionFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _descriptionFocus, _streetFocus);
        },
        controller: descriptionController,
      ),
      /// STREET ADDRESS
      ContactFormField(
        label: 'Street Address',
        textInputAction: TextInputAction.next,
        validationMessage: 'Please enter a street address',
        controller: streetController,
        isRequired: true,
        focus: _streetFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _streetFocus, _street2Focus);
        },
      ),
      /// STREET 2
      ContactFormField(
        label: 'Apt/Unit #',
        textInputAction: TextInputAction.next,
        isRequired: false,
        controller: street2Controller,
        focus: _street2Focus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _street2Focus, _cityFocus);
        },
      ),
      /// CITY
      ContactFormField(
        label: 'City',
        textInputAction: TextInputAction.next,
        validationMessage: 'Please enter a city.',
        controller: cityController,
        isRequired: true,
        focus: _cityFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _cityFocus, _zipFocus);
        },
      ),
      /// STATE
      FormField(
        builder: (FormFieldState<String> formState) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'State'
            ),
            isEmpty: state == null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: state,
                onChanged: (String value) {
                  formState.didChange(value);
                },
                items: StateHelper.statesArray.map((s) {
                  return DropdownMenuItem(
                    key: Key(s['abbreviation']),
                    value: s['abbreviation'],
                    child: Text('${s['name']}'),
                  );
                }).toList(),
              ),
            ),
          );
        },
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Please select a state.';
          }
          state = value;
        },
        autovalidate: true,
        initialValue: contact?.state,
      ),
      /// ZIP CODE
      ContactFormField(
        label: 'Zip Code',
        isRequired: true,
        textInputAction: TextInputAction.next,
        validationMessage: 'Please enter a zip code.',
        controller: zipController,
        focus: _zipFocus,
        onFieldSubmitted: (value) {
          _fieldFocusChange(context, _zipFocus, _notesFocus);
        },
      ),
      /// NOTES
      FormField(
        builder: (FormFieldState<String> formState) {
          return InputDecorator(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: 2,
              autocorrect: true,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  notes = value;
                }
              },
              focusNode: _notesFocus,
            ),
            decoration: InputDecoration(
              labelText: 'Notes',
            ),
          );
        },
      ),

      /// SUBMIT BUTTON
      Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: ButtonTheme.bar(
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('SAVE CONTACT',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      isLoading = true;
                    });

                    final user = userBloc.user;

                    var dto = Knock(
                      clientId: user?.session?.clientId,
                      firstName: firstNameController.value.text,
                      lastName: lastNameController.value.text,
                      description: descriptionController.value.text,
                      address: streetController.value.text,
                      addressCont: street2Controller.value.text,
                      city: cityController.value.text,
                      state: state,
                      zip: zipController.value.text,
                    );

                    if (contact != null) {
                      dto.dncContactId = contact.dncContactId;
                    }

                    var result = await bloc.saveKnock(dto);

                    if (result) {
                      _formKey.currentState?.reset();
                      setState(() {
                        isLoading = false;
                      });
                      
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Saved.'),
                        duration: Duration(milliseconds: 1500),
                      )).closed.then((value) {
                        if (dto.dncContactId != null) {
                          Navigator.pop(context, true);
                        } else {
                          Navigator.pop(context);
                        }
                      });
                    }
                  }
                },
                textColor: Colors.white,
              ),
            ],
          ),
          minWidth: MediaQuery.of(context).size.width * 0.75,
        ),
      ),
    ]);

    return widgets;
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}