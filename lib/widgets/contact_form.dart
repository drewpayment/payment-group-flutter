import 'package:flutter/material.dart';
import 'package:pay_track/bloc/contact_form_bloc.dart';
import 'package:pay_track/pages/manage_contacts.dart';
import 'package:pay_track/utils/state_hash.dart';
import 'package:pay_track/widgets/contact_form_provider.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> with TickerProviderStateMixin {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final streetFocus = FocusNode();
  final street2Focus = FocusNode();
  final cityFocus = FocusNode();
  final zipFocus = FocusNode();
  final notesFocus = FocusNode();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final streetController = TextEditingController();
  final street2Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final notesController = TextEditingController();

  ContactFormBloc bloc;

  bool isButtonPressed = false;

  final stateItems = StateHelper.statesArray.map((s) {
    return DropdownMenuItem(
      key: Key(s['abbreviation']),
      value: s['abbreviation'],
      child: Text('${s['name']}'),
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(updateFirstName);
    lastNameController.addListener(updateLastName);
    descriptionController.addListener(updateDescription);
    streetController.addListener(updateStreet);
    street2Controller.addListener(updateStreet2);
    cityController.addListener(updateCity);
    zipController.addListener(updateZip);
    notesController.addListener(updateNotes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = ContactFormProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            firstNameField,
            lastNameField,
            descriptionField,
            streetField,
            street2Field,
            cityField,
            stateField,
            zipField,
            notesField,
            saveButton,
          ],
        ),
      ),
    );
  }

  Widget get firstNameField {
    return StreamBuilder(
      stream: bloc.firstName,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'First Name',
            errorText: snap.error,
          ),
          onFieldSubmitted: (value) => _fieldFocusChange(context, firstNameFocus, lastNameFocus),
          focusNode: firstNameFocus,
          autofocus: true,
          validator: (value) => bloc.stringRequired(value, message: 'Please enter a first name.'),
          textInputAction: TextInputAction.next,
          controller: firstNameController,
        );  
      }
    );
  }

  Widget get lastNameField {
    return StreamBuilder(
      stream: bloc.lastName,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Last Name',
            errorText: snap.error,
          ),
          focusNode: lastNameFocus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, lastNameFocus, descriptionFocus),
          validator: (value) => bloc.stringRequired(value, message: 'Please enter a last name.'),
          textInputAction: TextInputAction.next,
          controller: lastNameController,
        );
      }
    );
  }

  Widget get descriptionField {
    return StreamBuilder(
      stream: bloc.description,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Description',
            errorText: snap.error,
          ),
          focusNode: descriptionFocus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, descriptionFocus, streetFocus),
          textInputAction: TextInputAction.next,
          controller: descriptionController,
        );
      },
    );
  }

  Widget get streetField {
    return StreamBuilder(
      stream: bloc.street,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Street',
            errorText: snap.error,
          ),
          controller: streetController,
          focusNode: streetFocus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, streetFocus, street2Focus),
          validator: (value) => bloc.stringRequired(value, message: 'Please enter a street.'),
          textInputAction: TextInputAction.next,
        );
      }
    );
  }

  Widget get street2Field {
    return StreamBuilder(
      stream: bloc.street2,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Apt/Unit/Suite #',
            errorText: snap.error,
          ),
          controller: street2Controller,
          focusNode: street2Focus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, street2Focus, cityFocus),
          textInputAction: TextInputAction.next,
        );
      }
    );
  }

  Widget get cityField {
    return StreamBuilder(
      stream: bloc.city,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'City',
            errorText: snap.error,
          ),
          controller: cityController,
          focusNode: cityFocus,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(FocusNode()),
          validator: (value) => bloc.stringRequired(value, message: 'Please enter a city.'),
          textInputAction: TextInputAction.next,
        );
      }
    );
  }

  Widget get stateField {
    return StreamBuilder(
      stream: bloc.state,
      builder: (context, AsyncSnapshot<String> snap) {
        return DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: 'State',
          ),
          value: snap.data,
          items: stateItems,
          onChanged: bloc.changeState,
          validator: (value) {
            if (value == null) return 'Please select a state.';
          },
        );
      }
    );
  }

  Widget get zipField {
    return StreamBuilder(
      stream: bloc.zip,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Zip',
            errorText: snap.error,
          ),
          controller: zipController,
          focusNode: zipFocus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, zipFocus, notesFocus),
          validator: bloc.stringRequired,
          textInputAction: TextInputAction.next,
        );
      }
    );
  }

  Widget get notesField {
    return StreamBuilder(
      stream: bloc.notes,
      builder: (context, snap) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: 'Note',
            errorText: snap.error,
          ),
          controller: notesController,
          focusNode: notesFocus,
          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(FocusNode()),
          textInputAction: TextInputAction.done,
        );
      }
    );
  }

  Widget get saveButton {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.save_alt, color: Colors.white),
            Text('Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        color: Theme.of(context).primaryColor,
        onPressed: isButtonPressed 
          ? null
          : _saveButtonHandler,
      ),
    );
  }

  void _saveButtonHandler() async {
    
    if (_formKey.currentState.validate()) {
      setState(() {
        isButtonPressed = !isButtonPressed;
        isLoading = true;
      });

      bloc.submit().then((resp) {
        Navigator.of(context, rootNavigator: true)
          ..pop()
          ..pop();

        if (resp.isOk()) {
          ManageContacts.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Saved new contact.'),
            duration: Duration(milliseconds: 2500),
            behavior: SnackBarBehavior.floating,
          ));
        } else {
          ManageContacts.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Network Error - ${resp.message}'),
            duration: Duration(milliseconds: 2000),
            behavior: SnackBarBehavior.floating,
          ));
        }
      });

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            ),
          );
        }
      );
    }
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void updateFirstName() => bloc.changeFirstName(firstNameController.text);
  void updateLastName() => bloc.changeLastName(lastNameController.text);
  void updateDescription() => bloc.changeDescription(descriptionController.text);
  void updateStreet() => bloc.changeStreet(streetController.text);
  void updateStreet2() => bloc.changeStreet2(street2Controller.text);
  void updateCity() => bloc.changeCity(cityController.text);
  void updateZip() => bloc.changeZip(zipController.text);
  void updateNotes() => bloc.changeNotes(notesController.text);


  @override
  void dispose() {
    firstNameController.removeListener(updateFirstName);
    lastNameController.removeListener(updateLastName);
    descriptionController.removeListener(updateDescription);
    streetController.removeListener(updateStreet);
    street2Controller.removeListener(updateStreet2);
    cityController.removeListener(updateCity);
    zipController.removeListener(updateZip);
    notesController.removeListener(updateNotes);
    bloc.dispose();
    super.dispose();
  }

}