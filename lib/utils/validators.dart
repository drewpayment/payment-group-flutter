
import 'dart:async';

class Validators {

  String stringRequired(String value) {
    if (value == null || value.isEmpty) {
      return 'Field required.';
    }
  }

}