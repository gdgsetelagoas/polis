import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:res_publica/data/account/account_data_source.dart';
import 'package:res_publica/ui/settings/bloc/bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AccountDataSource accountDataSource;

  SettingsBloc({@required this.accountDataSource});

  @override
  SettingsState get initialState => InitialSettingsState();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsSignOut) {
      var response = await accountDataSource.signOut();
      if (response.isSuccess)
        yield SettingsUserSignedOut();
      else
        yield SettingsErrors(errors: response.errors);
    }
  }
}
