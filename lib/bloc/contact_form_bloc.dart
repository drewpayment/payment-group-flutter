import 'dart:async';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/models/user.dart';
import 'package:pay_track/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ContactFormBloc extends Validators {
  final container = kiwi.Container();

  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();
  final _streetController = BehaviorSubject<String>();
  final _street2Controller = BehaviorSubject<String>();
  final _cityController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<String>();
  final _zipController = BehaviorSubject<String>();
  final _notesController = BehaviorSubject<String>();

  Stream<String> get firstName => _firstNameController.stream;
  Stream<String> get lastName => _lastNameController.stream;
  Stream<String> get description => _descriptionController.stream;
  Stream<String> get street => _streetController.stream;
  Stream<String> get street2 => _street2Controller.stream;
  Stream<String> get city => _cityController.stream;
  Stream<String> get state => _stateController.stream;
  Stream<String> get zip => _zipController.stream;
  Stream<String> get notes => _notesController.stream;

  Stream<bool> get submitValid => 
    Observable.combineLatest([firstName, lastName, street, city, state, zip], (l) => true);

  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;
  Function(String) get changeStreet => _streetController.sink.add;
  Function(String) get changeStreet2 => _street2Controller.sink.add;
  Function(String) get changeCity => _cityController.sink.add;
  Function(String) get changeState => _stateController.sink.add;
  Function(String) get changeZip => _zipController.sink.add;
  Function(String) get changeNotes => _notesController.sink.add;

  Future<ParsedResponse> submit() async {
    final user = container<User>();

    final dto = Knock(
      firstName: _firstNameController.value,
      lastName: _lastNameController.value,
      description: _descriptionController.value,
      address: _streetController.value,
      addressCont: _street2Controller.value,
      city: _cityController.value,
      state: _stateController.value,
      zip: _zipController.value,
      note: _notesController.value,
      clientId: user?.session?.clientId,
    );

    final contact = await bloc.saveKnock(dto);

    return ParsedResponse(contact != null ? 200 : 400, contact);
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
        print('Error: $name');
        sink.addError('Either Name or Description is required.');
      }
    });
  }

  StreamTransformer validateDescription() {
    return StreamTransformer<String, String>.fromHandlers(handleData: (desc, sink) {
      if (desc != null) {
        sink.add(desc);
      } else if (_firstNameController.value == null && _lastNameController.value == null) {
        print('Error: $desc');
        sink.addError('Either Name or Description is required.');
      }
    });
  }

}