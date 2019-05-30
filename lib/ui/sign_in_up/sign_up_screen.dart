import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_bloc.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_event.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_state.dart';
import 'package:res_publica/ui/utils/cpf_format_mask.dart';
import 'package:res_publica/ui/utils/patterns.dart' as Patterns;
import 'package:res_publica/ui/widgets/app_errors_dialog.dart';
import 'package:res_publica/ui/widgets/app_loading.dart';
import 'package:res_publica/ui/widgets/app_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isShowPass = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _cpfFocusNode = FocusNode();
  String _photoPath = "";
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
        title: Text("Registar"),
      ),
      body: BlocListener(
        bloc: bloc,
        listener: (c, s) {
          if (s is SignLoginSuccessful)
            Navigator.of(c).pop(s.user);
          else if (s is SignErrors)
            showDialog(
                context: context,
                builder: (c) => AppErrorsDialog(errors: s.errors));
        },
        child: BlocBuilder(
            bloc: bloc,
            builder: (c, s) => AppLoading(
                  processing: (s is SignLoading && s.loading),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height * 0.10),
                            bottom: 32.0),
                        child: Icon(
                          FontAwesomeIcons.userNinja,
                          size: 160.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      AppTextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _fullNameController,
                        focusNode: _fullNameFocusNode,
                        nextFocusNode: _emailFocusNode,
                        regexValidator: Patterns.fullName,
                        validatorMsgError: "Precisa ser nome completo.",
                        textColor: Colors.black,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Nome Completo",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.5)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: AppTextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          cursorColor: Theme.of(context).primaryColor,
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          nextFocusNode: _cpfFocusNode,
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
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.redAccent)),
                          ),
                        ),
                      ),
                      AppTextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(),
                        maxLines: 1,
                        cursorColor: Theme.of(context).primaryColor,
                        controller: _cpfController,
                        focusNode: _cpfFocusNode,
                        nextFocusNode: _passwordFocusNode,
                        textColor: Colors.black,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          CpfFormatMark()
                        ],
                        onChangeFocusValidate: (cpf) =>
                            Patterns.cpfValidate(cpf) ? null : "CPF inválido.",
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.credit_card),
                          labelText: "CPF",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.5)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red)),
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
                          obscureText: !_isShowPass,
                          cursorColor: Theme.of(context).primaryColor,
                          focusNode: _passwordFocusNode,
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
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.redAccent)),
                            suffixIcon: IconButton(
                                icon: Icon(_isShowPass
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash),
                                onPressed: () {
                                  _isShowPass = !_isShowPass;
                                  setState(() {});
                                }),
                            prefixIcon: Icon(Icons.vpn_key),
                            labelText: "Senha",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                bloc.dispatch(SignRegisterButtonPressed(
                                    user: UserEntity(
                                        name: _fullNameController.text,
                                        email: _emailController.text,
                                        cpf: _cpfController.text,
                                        password: _passwordController.text,
                                        photo: _photoPath)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Cadastrar"),
                              )),
                        ],
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
