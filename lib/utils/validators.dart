
import 'dart:async';

class Validators {

  final validateState = 
    StreamTransformer<String, String>.fromHandlers(handleData: (state, sink) {
      if (state == null) {
        sink.addError('Please select a state.');
      } else {
        sink.add(state);
      }
    });

  String stringRequired(String value, {String message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Field required.';
    }
  }

}