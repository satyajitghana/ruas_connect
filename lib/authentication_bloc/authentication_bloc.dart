import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ruas_connect/repository/user_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';
import 'package:ruas_connect/models/models.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final UserDetails userDetails = await _userRepository.getUserDetails();
        final bool isEmailVerified = await _userRepository.isEmailVerified;
        yield Authenticated(
          userDetails: userDetails,
          isEmailVerified: isEmailVerified,
        );
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    try {
      // if the document does not exist then dispatch the settings page
      final UserDetails userDetails = await _userRepository.getUserDetails();
      final bool isEmailVerfiied = await _userRepository.isEmailVerified;
      yield Authenticated(
        userDetails: userDetails,
        isEmailVerified: isEmailVerfiied,
      );
    } on UserDetailsFieldException {
      print('Exception : { found empty field } ');
      final uid = await _userRepository.getUid();
      final email = await _userRepository.getUserEmail();
      yield SetUserDetails(
        email: email,
        uid: uid,
      );
    } catch (_) {
      print('Error : $_');
      dispatch(LoggedOut());
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
