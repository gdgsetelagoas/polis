class RequestResponse<T> {
  final T data;
  final String code;
  final List<String> errors;

  RequestResponse({this.data, this.code, this.errors});

  RequestResponse.success(this.data, {this.code = "200"}) : this.errors = [];

  RequestResponse.fail(this.code, this.errors) : this.data = null;

  bool get isSuccess => (data != null && (code == "200" || code == "201"));
}
