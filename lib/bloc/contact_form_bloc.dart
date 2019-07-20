import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_track/utils/validators.dart';
import 'package:rxdart/rxdart.dart';

class ContactFormBloc extends Validators {
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _streetController = BehaviorSubject<String>();
  final _street2Controller = BehaviorSubject<String>();
  final _cityController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<String>();
  final _zipController = BehaviorSubject<String>();
  final _notesController = BehaviorSubject<String>();

  Stream<String> get firstName => _firstNameController.stream.transform(validateNameField());
  Stream<String> get lastName => _lastNameController.stream.transform(validateNameField());
  Stream<String> get description => _descriptionController.stream.transform(validateDescription());
  Stream<String> get street => _streetController.stream.transform(stringRequired);
  Stream<String> get street2 => _street2Controller.stream;
  Stream<String> get city => _cityController.stream.transform(stringRequired);
  Stream<String> get state => _stateController.stream.transform(stringRequired);
  Stream<String> get zip => _zipController.stream.transform(stringRequired);
  Stream<String> get notes => _notesController.stream;

  Stream<bool> get submitValid => 
    Observable.combineLatest([firstName, lastName, description, street, city, state, zip], (l) => true);

  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeStreet => _streetController.sink.add;
  Function(String) get changeStreet2 => _street2Controller.sink.add;
  Function(String) get changeCity => _cityController.sink.add;
  Function(String) get changeState => _stateController.sink.add;
  Function(String) get changeZip => _zipController.sink.add;
  Function(String) get changeNotes => _notesController.sink.add;

  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final streetFocus = FocusNode();
  final street2Focus = FocusNode();
  final cityFocus = FocusNode();
  final zipFocus = FocusNode();
  final notesFocus = FocusNode();

  submit() {
    final firstName = _firstNameController.value;
    final lastName = _lastNameController.value;
    final description = _descriptionController.value;
    final street = _streetController.value;
    final street2 = _street2Controller.value;
    final city = _cityController.value;
    final state = _stateController.value;
    final zip = _zipController.value;
    final notes = _notesController.value;

    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Description: $description');
    print('Street: $street');
    print('Street 2: $street2');
    print('City: $city');
    print('State: $state');
    print('Zip: $zip');
    print('Notes: $notes');
  }

  void dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _descriptionController.close();
    _streetController.close();
    _street2Controller.close();
    _cityController.close();
    _stateController.close();
    _zipController.close();
    _notesController.close();
  }

  StreamTransformer validateNameField() {
    return StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
      if (name != null) {
        sink.add(name);
      } else if (_descriptionController.value == null) {
        sink.addError('Either Name or Description is required.');
      }
    });
  }

  StreamTransformer validateDescription() {
    return StreamTransformer<String, String>.fromHandlers(handleData: (desc, sink) {
      if (desc != null) {
        sink.add(desc);
      } else if (_firstNameController.value == null && _lastNameController.value == null) {
        sink.addError('Either Name or Description is required.');
      }
    });
  }

}