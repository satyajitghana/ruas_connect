import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'Event : AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'Event : LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'Event : LoggedOut';
}
