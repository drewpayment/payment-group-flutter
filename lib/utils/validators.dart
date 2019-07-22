
import 'dart:async';

class Validators {

  String stringRequired(String value, {String message}) {
    if (value == null || value.isEmpty) {
      return message ?? 'Field required.';
    }
  }

}