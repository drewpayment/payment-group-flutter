

class ParsedResponse<T> {
  int statusCode;
  T body;
  String message;

  ParsedResponse(this.statusCode, this.body, {this.message});

  bool isOk() {
    return statusCode >= 200 && statusCode <= 300;
  }

  bool get hasError => statusCode < 200 || statusCode > 299;

  void mergeAll(ParsedResponse<T> merged) {
    merged.body = body;
    merged.statusCode = statusCode;
    merged.message = message;
  }

  void mergeStatus(ParsedResponse merged) {
    merged.statusCode = statusCode;
    merged.message = message;
  }
}