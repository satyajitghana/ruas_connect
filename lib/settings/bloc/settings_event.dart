import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ruas_connect/models/models.dart';

@immutable
abstract class SettingsEvent extends Equatable {
  SettingsEvent([List props = const []]) : super(props);
}

class UsernameChanged extends SettingsEvent {
  final String username;

  UsernameChanged({@required this.username}) : super([username]);

  @override
  String toString() => 'UsernameChanged { username : $username }';
}

class SaveProfileData extends SettingsEvent {
  final UserDetails userDetails;

  SaveProfileData({@required this.userDetails}) : super([userDetails]);
}
