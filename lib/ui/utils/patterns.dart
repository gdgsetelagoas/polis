final RegExp email = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a"
    r"-zA-Z0-9])?)*$",
    caseSensitive: false,
    multiLine: false);

final RegExp mobileBrazilianPhone = RegExp(
    r"^(\+?\d{1,3})? ?\(?0?\d{2}\)? ?9 ?\d{4}( |-)?\d{4}$",
    caseSensitive: false,
    multiLine: false);

final RegExp brazilianZipCode =
    RegExp(r"^\d{5}[. -]?\d{3}$", caseSensitive: false, multiLine: false);

final RegExp dateMDY = RegExp(
    r"^(1[012]{1}|0?[1-9])[/\-.][0123]?([123]{1}\d|0?\d)[/\-.](\d{4}|\d{2})$",
    caseSensitive: false,
    multiLine: false);

final RegExp dateDMY = RegExp(
    r"^[0123]?([123]{1}\d|0?\d)[/\-.](1[012]{1}|0?[1-9])[/\-.](\d{4}|\d{2})$",
    caseSensitive: false,
    multiLine: false);

final RegExp fullName = RegExp(
    r"^[\waAáÁâÂàÀäÄãÃeEéÉêÊèÈëËiIíÍîÎìÌïÏoOóÓôÔòÒöÖõÕuUúÚûÛùÙüÜcCçÇ']{2,}"
    r"([ \waAáÁâÂàÀäÄãÃeEéÉêÊèÈëËiIíÍîÎìÌïÏoOóÓôÔòÒöÖõÕuUúÚûÛùÙüÜcCçÇ']{1,})*$");

final RegExp postalCode = RegExp(r"^\d{5,5}-?\d{3,3}$");

final RegExp firebaseAuthError = RegExp(r"\((.*?),(.*?),(.*?)\)");

final RegExp cpf = RegExp(r"^\d{3,3}\.?\d{3,3}\.?\d{3,3}-?\d{2,2}$");

final RegExp cnpj =
    RegExp(r"^\d{2,2}\.?\d{3,3}\.?\d{3,3}\/?\d{4,4}\-?\d{2,2}$");

bool cpfValidate(String cpfTest) {
  if (!cpf.hasMatch(cpfTest)) return false;
  var digitsString = cpfTest.replaceAll(RegExp(r"\.|-"), "").split("");
  if (digitsString.every((e) => cpfTest[0] == e)) return false;
  var digitsNumbers = digitsString.map((s) => int.parse(s)).toList();
  return _cpfAlgorithm(digitsNumbers.getRange(0, 9).toList(), digitsNumbers[9],
      digitsNumbers[10]);
}

bool _cpfAlgorithm(List<int> numbers, int firstValidator, int secondValidator) {
  int first = 0;
  int second = 0;
  int pos = 0;
  numbers.forEach((number) {
    first = number * (10 - pos) + first;
    second = number * (11 - pos) + second;
    pos++;
  });
  second = firstValidator * (11 - pos) + second;
  if (first % 11 < 2 && firstValidator != 0) return false;
  if (first % 11 >= 2 && (11 - (first % 11)) != firstValidator) return false;
  if (second % 11 < 2 && secondValidator != 0) return false;
  if (second % 11 >= 2 && (11 - (second % 11)) != secondValidator) return false;
  return true;
}

bool cnpjValidate(String cnpjTest) {
  //TODO implementar validação de cnpj
  return cnpj.hasMatch(cnpjTest);
}
