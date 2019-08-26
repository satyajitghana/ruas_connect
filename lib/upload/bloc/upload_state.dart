import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UploadState extends Equatable {
  UploadState([List props = const []]) : super(props);
}

class UploadError extends UploadState {
  final String error;

  UploadError({@required this.error}) : super([error]);
}

class UploadFormState extends UploadState {
  final bool isTitleValid;
  final bool isDescriptionValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  UploadFormState(
      {@required this.isTitleValid,
      @required this.isDescriptionValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure})
      : super([
          isTitleValid,
          isDescriptionValid,
          isSubmitting,
          isSuccess,
          isFailure
        ]);

  bool get isFormValid => isTitleValid && isDescriptionValid;

  factory UploadFormState.empty() {
    return UploadFormState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory UploadFormState.loading() {
    return UploadFormState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory UploadFormState.failure() {
    return UploadFormState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory UploadFormState.success() {
    return UploadFormState(
      isTitleValid: true,
      isDescriptionValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  UploadFormState update({
    bool isTitleValid,
    bool isDescriptionValid,
  }) {
    return copyWith(
      isTitleValid: isTitleValid,
      isDescriptionValid: isDescriptionValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  UploadFormState copyWith({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return UploadFormState(
      isTitleValid: isTitleValid ?? this.isTitleValid,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''UploadFormState {
      isTitleValid: $isTitleValid,
      isDescriptionValid: $isDescriptionValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}

/// THIS IS PROBABLY GOING TO BE USED LATER

class UploadFileState extends UploadState {
  final bool isUploadedToFirebaseStorage;
  final bool isWrittenToFireStore;
  final bool isUploading;

  UploadFileState(
      {@required this.isUploading,
      @required this.isUploadedToFirebaseStorage,
      @required this.isWrittenToFireStore})
      : super([isUploadedToFirebaseStorage, isWrittenToFireStore]);

  bool get isValidUpload => isUploadedToFirebaseStorage && isWrittenToFireStore;

  factory UploadFileState.init() {
    return UploadFileState(
      isUploadedToFirebaseStorage: false,
      isWrittenToFireStore: false,
      isUploading: false,
    );
  }

  factory UploadFileState.success() {
    return UploadFileState(
      isUploadedToFirebaseStorage: true,
      isWrittenToFireStore: true,
      isUploading: false,
    );
  }

  factory UploadFileState.uploading() {
    return UploadFileState(
      isUploadedToFirebaseStorage: false,
      isWrittenToFireStore: false,
      isUploading: true,
    );
  }

  factory UploadFileState.failedFireStore() {
    return UploadFileState(
      isUploadedToFirebaseStorage: true,
      isWrittenToFireStore: false,
      isUploading: false,
    );
  }

  UploadFileState update({
    bool isUploadedToFirebaseStorage,
    bool isWrittenToFireStore,
    bool isUploading,
  }) {
    return copyWith(
        isWrittenToFireStore: isWrittenToFireStore,
        isUploadedToFirebaseStorage: isUploadedToFirebaseStorage,
        isUploading: isUploading);
  }

  UploadFileState copyWith({
    bool isUploadedToFirebaseStorage,
    bool isWrittenToFireStore,
    bool isUploading,
  }) {
    return UploadFileState(
        isUploadedToFirebaseStorage:
            isUploadedToFirebaseStorage ?? this.isUploadedToFirebaseStorage,
        isWrittenToFireStore: isWrittenToFireStore ?? this.isWrittenToFireStore,
        isUploading: isUploading ?? this.isUploading);
  }
}
