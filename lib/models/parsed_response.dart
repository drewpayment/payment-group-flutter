

class ParsedResponse<T> {
  final int statusCode;
  final T body;
  final String message;

  ParsedResponse(this.statusCode, this.body, {this.message});

  bool isOk() {
    return statusCode >= 200 && statusCode <= 300;
  }

  bool get hasError => statusCode < 200 || statusCode > 299;
}