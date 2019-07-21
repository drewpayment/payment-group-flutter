import 'package:flutter/material.dart';
import 'package:pay_track/bloc/contact_form_bloc.dart';
import 'package:pay_track/utils/state_hash.dart';
import 'package:pay_track/widgets/contact_form_provider.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {

  final _formKey = GlobalKey<FormState>();

  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final streetFocus = FocusNode();
  final street2Focus = FocusNode();
  final cityFocus = FocusNode();
  final zipFocus = FocusNode();
  final notesFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final bloc = ContactFormProvider.of(context);

    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            firstNameField(bloc),
            lastNameField(bloc),
            descriptionField(bloc),
            streetField(bloc),
            street2Field(bloc),
            cityField(bloc),
            stateField(bloc),
            zipField(bloc),
            notesField(bloc),
            saveButton(bloc),
          ],
        ),
      ),
    );
  }

  Widget firstNameField(ContactFormBloc bloc) {
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
          autofocus: false,
          validator: (value) {
            if (value.isEmpty) {
              return 'First name required.';
            }
          },
        );  
      }
    );
  }

  Widget lastNameField(ContactFormBloc bloc) {
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
          validator: bloc.stringRequired,
        );
      }
    );
  }

  Widget descriptionField(ContactFormBloc bloc) {
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
          validator: bloc.stringRequired,
        );
      },
    );
  }

  Widget streetField(ContactFormBloc bloc) {
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
          validator: bloc.stringRequired,
        );
      }
    );
  }

  Widget street2Field(ContactFormBloc bloc) {
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
        );
      }
    );
  }

  Widget cityField(ContactFormBloc bloc) {
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
          validator: bloc.stringRequired,
        );
      }
    );
  }

  Widget stateField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.state,
      builder: (context, snap) {
        return FormField(
          builder: (state) {
            return Column(
              children: <Widget>[
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'State',
                    errorText: snap.error,
                  ),
                  isEmpty: !snap.hasData,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: snap.data,
                      onChanged: (value) {
                        // bloc.changeState(value);
                        FocusScope.of(context).requestFocus(FocusNode());
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
                ),
                SizedBox(height: 5),
                Text(state.hasError ? state.errorText : '',
                  style: TextStyle(
                    color: Colors.redAccent.shade700,
                    fontSize: 12,
                    decorationColor: Colors.redAccent.shade700,
                  ),
                ),
              ],
            );
          },
          onSaved: bloc.changeState,
          validator: bloc.stringRequired,
          autovalidate: false,
          enabled: true,
        );
      }
    );
  }

  Widget zipField(ContactFormBloc bloc) {
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
        );
      }
    );
  }

  Widget notesField(ContactFormBloc bloc) {
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
          validator: bloc.stringRequired,
        );
      }
    );
  }

  Widget saveButton(ContactFormBloc bloc) {
    
    return RaisedButton(
      child: Text('Save'),
      color: Theme.of(context).primaryColor.withOpacity(0.45),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          bloc.submit();
        }
      },
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}