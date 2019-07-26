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

  // AnimationController _controller;
  // Animation _animation;

  ContactFormBloc bloc;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // _animation = Tween(begin: 0.0, end: 300).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = ContactFormProvider.of(context);

    // firstNameFocus.addListener(() => firstNameFocus.hasFocus ? _controller.forward() : _controller.reverse());
    // lastNameFocus.addListener(() => scrollFocus(lastNameFocus));
    // descriptionFocus.addListener(() => scrollFocus(descriptionFocus));
    // streetFocus.addListener(() => scrollFocus(streetFocus));
    // street2Focus.addListener(() => scrollFocus(street2Focus));
    // cityFocus.addListener(() => scrollFocus(cityFocus));
    // notesFocus.addListener(() => notesFocus.hasFocus ? _controller.forward() : _controller.reverse());
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
          onSaved: bloc.changeFirstName,
          focusNode: firstNameFocus,
          autofocus: true,
          validator: (value) => bloc.stringRequired(value, message: 'Please enter a first name.'),
          textInputAction: TextInputAction.next,
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
          onSaved: bloc.changeLastName,
          focusNode: lastNameFocus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, lastNameFocus, descriptionFocus),
          validator: (value) => bloc.stringRequired(value, message: 'Please enter a last name.'),
          textInputAction: TextInputAction.next,
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
          onSaved: bloc.changeDescription,
          focusNode: descriptionFocus,
          onFieldSubmitted: (value) => _fieldFocusChange(context, descriptionFocus, streetFocus),
          textInputAction: TextInputAction.next,
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
          onSaved: bloc.changeStreet,
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
          onSaved: bloc.changeStreet2,
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
          onSaved: bloc.changeCity,
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
          items: StateHelper.statesArray.map((s) {
            return DropdownMenuItem(
              key: Key(s['abbreviation']),
              value: s['abbreviation'],
              child: Text('${s['name']}'),
            );
          }).toList(),
          onChanged: bloc.changeState,
          onSaved: bloc.changeState,
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
          onSaved: bloc.changeZip,
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
          onSaved: bloc.changeNotes,
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
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            isLoading = true;

            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                bloc.submit().then((resp) {
                  Navigator.of(context, rootNavigator: true).pop();

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
        },
      ),
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

}