import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_bloc.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_event.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_state.dart';
import 'package:res_publica/ui/sign_in_up/sign_up_screen.dart';
import 'package:res_publica/ui/utils/patterns.dart' as Patterns;
import 'package:res_publica/ui/widgets/app_errors_dialog.dart';
import 'package:res_publica/ui/widgets/app_loading.dart';
import 'package:res_publica/ui/widgets/app_text_form_field.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isShowPass = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  SignBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<SignBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrar"),
      ),
      body: BlocListener(
        bloc: bloc,
        listener: (context, state) {
          if (state is SignRegister) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (c) => BlocProvider(
                          child: SignUpScreen(),
                          builder: (BuildContext context) => bloc,
                        )))
                .then((user) {
              if (user != null) Navigator.of(context).pop(user);
            });
          } else if (state is SignErrors) {
            showDialog(
                context: context,
                builder: (con) => AppErrorsDialog(
                      errors: state.errors,
                    ));
          } else if (state is SignLoginSuccessful) {
            Navigator.of(context).pop(state.user);
          }
        },
        child: BlocBuilder<SignBloc, SignState>(
          bloc: bloc,
          builder: (cont, state) {
            return AppLoading(
              processing: (state is SignLoading && state.loading),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height * 0.15),
                        bottom: 32.0),
                    child: Icon(
                      FontAwesomeIcons.userCircle,
                      size: 160.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  AppTextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    nextFocusNode: _passwordFocusNode,
                    regexValidator: Patterns.email,
                    validatorMsgError: "Email inválido.",
                    textColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.alternate_email),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3.5)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: AppTextFormField(
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: !_isShowPass,
                      cursorColor: Theme.of(context).primaryColor,
                      regexValidator: RegExp(r".{6,}"),
                      validatorMsgError: "Senha muito curta.",
                      textColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 3.5)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        suffixIcon: IconButton(
                            icon: Icon(_isShowPass
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash),
                            onPressed: () {
                              _isShowPass = !_isShowPass;
                              setState(() {});
                            }),
                        labelText: "Senha",
                        prefixIcon: Icon(Icons.vpn_key),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            bloc.add(SignRegisterButtonPressed());
                          },
                          child: Text("Cadastrar",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor))),
                      OutlineButton(
                        onPressed: () {
                          bloc.add(SignLoginWithGooglePressed());
                        },
                        child: Icon(
                          FontAwesomeIcons.google,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: OutlineButton(
                          onPressed: () {
                            bloc.add(SignLoginButtonPressed(
                                email: _emailController.text,
                                password: _passwordController.text));
                          },
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
