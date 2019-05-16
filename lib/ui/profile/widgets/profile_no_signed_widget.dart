import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';

class ProfileNoSignedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<ProfileBloc>(context);
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Você não está logado vacilão, fica esperto vai em login e se autentica!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
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
