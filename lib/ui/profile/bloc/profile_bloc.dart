import 'package:bloc/bloc.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';
import 'package:res_publica/ui/profile/bloc/profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountDataSource _accountDataSource;
  ProfileState _state = ProfileNotSigned();

  ProfileBloc(this._accountDataSource) {
    _accountDataSource.onAuthStateChange().listen((user) {
      dispatch(user == null
          ? ProfileUserAuthenticatedFail()
          : ProfileUserAuthenticated(user: user));
    });
  }

  @override
  ProfileState get initialState {
    return _state;
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileUserAuthenticating) {
      yield ProfileLoading(true);
      var user = await _accountDataSource.currentUser;
      if (user == null)
        _state = ProfileNotSigned();
      else
        _state = ProfileSigned(user: user);
      yield _state;
      yield ProfileLoading(false);
    }

    if (event is ProfileUserAuthenticated) {
      _state = ProfileSigned(user: event.user);
      yield _state;
    }

    if (event is ProfileUserAuthenticatedFail) {
      _state = ProfileNotSigned();
      yield _state;
    }

    if (event is ProfileUpdatingName && event.editing)
      yield ProfileEditingName();

    if (event is ProfileUpdatePhoto) {
      var user = await _accountDataSource.currentUser;
      if (user == null)
        yield ProfileNotSigned();
      else {
        var response =
            await _accountDataSource.updateAccount(user..photo = event.path);
        if (response.isSuccess)
          yield ProfileSigned(user: response.data);
        else {
          yield ProfileSigned(user: user);
          yield ProfileErrors(errors: response.errors);
        }
      }
    }

    if (event is ProfileUpdateName) {
      var user = await _accountDataSource.currentUser;
      if (user == null)
        yield ProfileNotSigned();
      else {
        var response =
            await _accountDataSource.updateAccount(user..name = event.name);
        if (response.isSuccess)
          yield ProfileSigned(user: response.data);
        else {
          yield ProfileSigned(user: user);
          yield ProfileErrors(errors: response.errors);
        }
      }
    }
  }
}
