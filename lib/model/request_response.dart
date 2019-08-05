class RequestResponse<T> {
  final T data;
  final String code;
  final List<String> errors;

  RequestResponse({this.data, this.code, this.errors});

  RequestResponse.success(this.data, {this.code = "200"}) : this.errors = [];

  RequestResponse.fail(this.code, this.errors) : this.data = null;

  RequestResponse.notFound({String resource})
      : this.fail("404", [
          "O recurso ${resource + (resource.isNotEmpty ? " " : "")}não foi encontrado"
        ]);

  RequestResponse.authFail({String action})
      : this.fail("403", [
          "Você precisa de está logado para $action${action.isNotEmpty ? "" : "fazer isso"}."
        ]);

  bool get isSuccess => (data != null && (code == "200" || code == "201"));
}
