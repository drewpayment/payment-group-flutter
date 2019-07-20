

import 'package:flutter/material.dart';
import 'package:pay_track/bloc/contact_form_bloc.dart';
import 'package:pay_track/utils/state_hash.dart';
import 'package:pay_track/widgets/contact_form_provider.dart';

class ContactForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = ContactFormProvider.of(context);

    return Container(
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
    );
  }

  Widget firstNameField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.firstName,
      builder: (context, snap) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'First Name',
            errorText: snap.error,
          ),
          controller: TextEditingController(text: snap.data),
          onChanged: bloc.changeFirstName,
          focusNode: bloc.firstNameFocus,
          onSubmitted: (value) => _fieldFocusChange(context, bloc.firstNameFocus, bloc.lastNameFocus),
          autofocus: false,
        );  
      }
    );
  }

  Widget lastNameField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.lastName,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'Last Name',
            errorText: snap.error,
          ),
          onChanged: bloc.changeLastName,
          focusNode: bloc.lastNameFocus,
          onSubmitted: (value) => _fieldFocusChange(context, bloc.lastNameFocus, bloc.descriptionFocus),
        );
      }
    );
  }

  Widget descriptionField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.description,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'Description',
            errorText: snap.error,
          ),
          onChanged: bloc.changeDescription,
          focusNode: bloc.descriptionFocus,
          onSubmitted: (value) => _fieldFocusChange(context, bloc.descriptionFocus, bloc.streetFocus),
        );
      },
    );
  }

  Widget streetField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.street,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'Street',
            errorText: snap.error,
          ),
          onChanged: bloc.changeStreet,
          focusNode: bloc.streetFocus,
          onSubmitted: (value) => _fieldFocusChange(context, bloc.streetFocus, bloc.street2Focus),
        );
      }
    );
  }

  Widget street2Field(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.street2,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'Apt/Unit/Suite #',
            errorText: snap.error,
          ),
          onChanged: bloc.changeStreet2,
          focusNode: bloc.street2Focus,
          onSubmitted: (value) => _fieldFocusChange(context, bloc.street2Focus, bloc.cityFocus),
        );
      }
    );
  }

  Widget cityField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.city,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'City',
            errorText: snap.error,
          ),
          onChanged: bloc.changeCity,
          focusNode: bloc.cityFocus,
          onSubmitted: (value) => FocusScope.of(context).requestFocus(FocusNode()),
        );
      }
    );
  }

  Widget stateField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.state,
      builder: (context, snap) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'State',
            errorText: snap.error,
          ),
          isEmpty: !snap.hasData,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: snap.data,
              onChanged: (value) {
                bloc.changeState(value);
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
        );
      }
    );
  }

  Widget zipField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.zip,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'Zip',
            errorText: snap.error,
          ),
          onChanged: bloc.changeZip,
          focusNode: bloc.zipFocus,
          onSubmitted: (value) => _fieldFocusChange(context, bloc.zipFocus, bloc.notesFocus),
        );
      }
    );
  }

  Widget notesField(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.notes,
      builder: (context, snap) {
        return TextField(
          controller: TextEditingController(text: snap.data),
          decoration: InputDecoration(
            labelText: 'Note',
            errorText: snap.error,
          ),
          onChanged: bloc.changeNotes,
          focusNode: bloc.notesFocus,
          onSubmitted: (value) => FocusScope.of(context).requestFocus(FocusNode()),
        );
      }
    );
  }

  Widget saveButton(ContactFormBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return RaisedButton(
          child: Text('Save'),
          color: Theme.of(context).primaryColor.withOpacity(0.45),
          onPressed: snap.hasData ? bloc.submit : null,
        );
      }
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}