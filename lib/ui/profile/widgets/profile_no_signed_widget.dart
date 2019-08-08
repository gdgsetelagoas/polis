import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';

class ProfileNoSignedWidget extends StatelessWidget {
  final ProfileBloc bloc;

  const ProfileNoSignedWidget({Key key, this.bloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Opacity(
              opacity: 0.75,
              child: Icon(
                FontAwesomeIcons.userSecret,
                size: 96.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Você não está logado!.\nClica aqui em login e se autentica!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            OutlineButton(
              onPressed: () {
                bloc.dispatch(ProfileUserAuthenticating());
              },
              child: Text("Login"),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
