import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ruas_connect/models/models.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'State : Uninitialized';
}

class Authenticated extends AuthenticationState {
  final UserDetails userDetails;
  final bool isEmailVerified;

  Authenticated({ this.userDetails, this.isEmailVerified }) : super([userDetails, isEmailVerified]);

  @override
  String toString() =>
      'State : Authenticated { displayName: ${userDetails.userName} }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'State : Unauthenticated';
}

class SetUserDetails extends AuthenticationState {
  final String uid;
  final String email;

  SetUserDetails({this.uid, this.email}) : super([uid, email]);
}
