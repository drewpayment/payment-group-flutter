

class Helpers {

  static bool isNumeric(s) {
    var test = '$s';
    if (test == null) {
      return false;
    }
    return (double.tryParse(test) ?? null) != null;
  }

}