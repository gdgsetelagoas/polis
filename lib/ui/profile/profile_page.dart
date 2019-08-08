import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:res_publica/main.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';
import 'package:res_publica/ui/profile/bloc/profile_states.dart';
import 'package:res_publica/ui/profile/widgets/profile_no_signed_widget.dart';
import 'package:res_publica/ui/profile/widgets/profile_signed_widget.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_bloc.dart';
import 'package:res_publica/ui/sign_in_up/sign_in_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _lastState = Container();
  ProfileBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<ProfileBloc>(context);
    bloc.dispatch(ProfileUserAuthenticating());
    bloc.event.listen(_events);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocBuilder<ProfileBloc, ProfileState>(
          bloc: bloc,
          condition: (oldState, newState) {
            if (newState is ProfileNotSigned || newState is ProfileSigned)
              return true;
            return false;
          },
          builder: (con, state) {
            if (state is ProfileNotSigned)
              return ProfileNoSignedWidget(bloc: bloc);
            if (state is ProfileSigned)
              return ProfileSignedWidget(
                bloc: bloc,
                user: state.user,
              );
            return SizedBox();
          },
        ),
        Positioned(
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is ProfileLoading && state.loading)
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  );
                return SizedBox();
              },
            ),
          ),
        ),
      ],
    );
  }

  _events(ProfileEvent event) {
    if (event is ProfileUserAuthenticating)
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (c) => BlocProvider(
                    builder: (_) => injector.get<SignBloc>("SignBloc"),
                    child: SignInScreen(),
                  )))
          .then((user) {
        bloc.dispatch(user == null
            ? ProfileUserAuthenticatedFail()
            : ProfileUserAuthenticated(user: user));
      });
  }
}
