
import 'dart:async';

class Validators {

  final stringRequired = StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value != null) {
      sink.add(value);
    } else {
      sink.addError('Please enter a value.');
    }
  });

}