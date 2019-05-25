import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:res_publica/ui/widgets/app_errors_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SettingsBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
      ),
      body: BlocListener(
        bloc: bloc,
        listener: (context, state) {
          if (state is SettingsUserSignedOut) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Conta deslogada com sucesso"),
              duration: Duration(seconds: 3),
            ));
          } else if (state is SettingsErrors) {
            showDialog(
                context: context,
                builder: (c) => AppErrorsDialog(errors: state.errors));
          }
        },
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () {
                    bloc.dispatch(SettingsSignOut());
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.doorOpen,
                        color: Colors.grey.shade700,
                      ),
                      Spacer(),
                      Text(
                        "Sair",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 18.0),
                      ),
                    ],
                  )),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () async {
                    if (await canLaunch(
                        "https://firebasestorage.googleapis.com/v0/b/res-publica-76d21.appspot.com/o/terms%2Fterms-v1.pdf?alt=media&token=1daa72d5-acdb-4c10-8916-55888dedc220")) {
                      launch(
                          "https://firebasestorage.googleapis.com/v0/b/res-publica-76d21.appspot.com/o/terms%2Fterms-v1.pdf?alt=media&token=1daa72d5-acdb-4c10-8916-55888dedc220");
                    }
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.fileContract,
                        color: Colors.grey.shade700,
                      ),
                      Spacer(),
                      Text(
                        "Termos de Uso",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 18.0),
                      ),
                    ],
                  )),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
