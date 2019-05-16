import 'package:flutter/material.dart';

class AppErrorsDialog extends StatelessWidget {
  final List<String> errors;
  final String title;
  final String closeText;

  const AppErrorsDialog({
    Key key,
    @required this.errors,
    this.title = "Um ou mais erros ocorreram!",
    this.closeText = "Ok 😒",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 96.0,
              ),
            ),
          ),
          Text(
            "- " + errors.join("\n- "),
            style: TextStyle(color: Colors.redAccent),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(closeText))
      ],
    );
  }
}
