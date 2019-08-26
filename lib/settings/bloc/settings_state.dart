import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ruas_connect/models/models.dart';

@immutable
abstract class SettingsState extends Equatable {
  SettingsState([List props = const []]) : super(props);
}

class InitialSettingsState extends SettingsState {}

class SettingsSavedSuccessful extends SettingsState {
  final UserDetails userDetails;

  SettingsSavedSuccessful({this.userDetails}) : super([userDetails]);
}

class SettingsFormSaveError extends SettingsState {
  final String error;

  SettingsFormSaveError(this.error);

  @override
  String toString() => 'SettingsFormSaveError : { $error }';
}

class SettingsFormState extends SettingsState {
  final bool isUsernameValid;
  final bool isBranchValid;
  final bool isSemesterValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  SettingsFormState(
      {@required this.isUsernameValid,
      @required this.isBranchValid,
      @required this.isSemesterValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure})
      : super([
          isUsernameValid,
          isBranchValid,
          isSemesterValid,
          isSubmitting,
          isSuccess,
          isFailure
        ]);

  bool get isFormValid => isUsernameValid && isBranchValid && isSemesterValid;

  factory SettingsFormState.empty() {
    return SettingsFormState(
      isUsernameValid: true,
      isBranchValid: true,
      isSemesterValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SettingsFormState.loading() {
    return SettingsFormState(
      isUsernameValid: true,
      isBranchValid: true,
      isSemesterValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory SettingsFormState.failure() {
    return SettingsFormState(
      isUsernameValid: true,
      isBranchValid: true,
      isSemesterValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory SettingsFormState.success() {
    return SettingsFormState(
      isUsernameValid: true,
      isBranchValid: true,
      isSemesterValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  SettingsFormState update(
      {bool isUsernameValid, bool isBranchValid, bool isSemesterValid}) {
    return copyWith(
      isUsernameValid: isUsernameValid,
      isBranchValid: isBranchValid,
      isSemesterValid: isSemesterValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  SettingsFormState copyWith({
    bool isUsernameValid,
    bool isBranchValid,
    bool isSemesterValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return SettingsFormState(
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isBranchValid: isBranchValid ?? this.isBranchValid,
      isSemesterValid: isSemesterValid ?? this.isSemesterValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''SettingsFormState {
      isUsernameValid: $isUsernameValid,
      isBranchValid: $isBranchValid,
      isSemesterValid: $isSemesterValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
