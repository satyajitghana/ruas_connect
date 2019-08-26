import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ruas_connect/settings/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ruas_connect/validators.dart';
import 'package:ruas_connect/models/models.dart';
import 'package:ruas_connect/repository/respository.dart';
import 'package:meta/meta.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UserRepository _userRepository;

  SettingsBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SettingsState get initialState => SettingsFormState.empty();

  @override
  Stream<SettingsState> transform(Stream<SettingsEvent> events,
      Stream<SettingsState> next(SettingsEvent event)) {
    final observableStream = events as Observable<SettingsEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! UsernameChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is UsernameChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    } else if (event is SaveProfileData) {
      yield* _mapSaveProfileDataToState(event.userDetails);
    }
  }

  Stream<SettingsState> _mapUsernameChangedToState(String username) async* {
    yield (currentState as SettingsFormState)
        .update(isUsernameValid: Validators.isValidUsername(username));
  }

  Stream<SettingsState> _mapSaveProfileDataToState(
      UserDetails userDetails) async* {
    try {
      yield SettingsFormState.loading();
      await _userRepository.updateProfileDetails(userDetails.uid,
          userDetails.userName, userDetails.branch, userDetails.semester);
      yield SettingsFormState.success();
//      yield SettingsSavedSuccessful(userDetails: userDetails);
    } catch (error) {
      yield SettingsFormSaveError('Error : $error');
      yield SettingsFormState.failure();
    }
  }
}
