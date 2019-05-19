import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

Widget dialogImage(BuildContext context) {
  return AlertDialog(
    title: Text("Selecionar imagem da:"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.fileImage),
                Spacer(),
                Text("Galeria")
              ],
            )),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.camera),
                Spacer(),
                Text("Camera")
              ],
            )),
      ],
    ),
  );
}

Widget dialogVideo(BuildContext context) {
  return AlertDialog(
    title: Text("Selecionar vídeo da:"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.fileVideo),
                Spacer(),
                Text("Galeria")
              ],
            )),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.video),
                Spacer(),
                Text("Camera")
              ],
            )),
      ],
    ),
  );
}

Widget dialogConfirmCancel(BuildContext context) {
  return AlertDialog(
    title: Text("Confirmar"),
    content: Text("Tem certeza que deseja descartar a publicação?"),
    actions: <Widget>[
      FlatButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text("Descartar Publicação")),
      FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text("Continuar Editando")),
    ],
  );
}
