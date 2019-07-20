import 'package:flutter/material.dart';
import 'package:pay_track/bloc/contact_form_bloc.dart';

class ContactFormProvider extends InheritedWidget {
  final bloc = ContactFormBloc();

  ContactFormProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static ContactFormBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ContactFormProvider) as ContactFormProvider)?.bloc;
  }
}