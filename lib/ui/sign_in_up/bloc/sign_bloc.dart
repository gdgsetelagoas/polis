import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_event.dart';
import 'package:res_publica/ui/sign_in_up/bloc/sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  final AccountDataSource accountDataSource;
  final GoogleSignIn googleSignIn;

  SignBloc({@required this.accountDataSource, @required this.googleSignIn});

  @override
  SignState get initialState => SignInitial();

  @override
  Stream<SignState> mapEventToState(SignEvent event) async* {
    yield SignLoading();
    if (event is SignLoginWithGooglePressed) {
      yield await _signInGoogle(event);
    } else if (event is SignLoginButtonPressed) {
      yield await _signInEmailPass(event);
    } else if (event is SignRegisterButtonPressed) {
      if (event.user == null)
        yield SignRegister();
      else {
        yield await _register(event);
      }
    }
    yield SignLoading(false);
  }

  Future<SignState> _signInGoogle(SignLoginWithGooglePressed event) async {
    try {
      var google = await googleSignIn.signIn().then((v) => print(v));
      var currentUser = googleSignIn.currentUser;
      var response = await accountDataSource.signInWithGoogle(currentUser);
      if (response.isSuccess)
        return SignLoginSuccessful(response.data);
      else
        return SignErrors(response.errors);
    } catch (er, stack) {
      print("$er\n$stack");
      return SignErrors([er.toString()]);
    }
  }

  Future<SignState> _signInEmailPass(SignLoginButtonPressed event) async {
    var errors = <String>[];
    if (event.password?.isEmpty ?? true)
      errors.add("Senha não pode ser em branco");
    if (event.email?.isEmpty ?? true)
      errors.add("Email não pode ser em branco");
    if (errors.length >= 1)
      return SignErrors(errors);
    else {
      var response =
          await accountDataSource.signIn(event.email, event.password);
      if (response.isSuccess)
        return SignLoginSuccessful(response.data);
      else
        return SignErrors(response.errors);
    }
  }

  Future<SignState> _register(SignRegisterButtonPressed event) async {
    var response = await accountDataSource.register(event.user);
    if (response.isSuccess)
      return SignLoginSuccessful(response.data);
    else
      return SignErrors(response.errors);
  }
}
