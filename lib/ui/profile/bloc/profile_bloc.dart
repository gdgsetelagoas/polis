import 'package:bloc/bloc.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/ui/profile/bloc/profile_events.dart';
import 'package:res_publica/ui/profile/bloc/profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountDataSource _accountDataSource;

  ProfileBloc(this._accountDataSource);

  @override
  ProfileState get initialState {
    dispatch(ProfileUserAuthenticating());
    return ProfileNotSigned();
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    yield ProfileLoading();

    if (event is ProfileUserAuthenticating) {
      var user = await _accountDataSource.currentUser;
      if (user == null)
        yield ProfileNotSigned();
      else
        yield ProfileSigned(user: user);
    }

    if (event is ProfileUserAuthenticated) {
      await Future.delayed(Duration(milliseconds: 750));
      yield ProfileSigned();
    }

    if (event is ProfileUpdatingName && event.editing)
      yield ProfileEditingName();
    if (event is ProfileUpdateName) yield ProfileSigned();
  }
}
