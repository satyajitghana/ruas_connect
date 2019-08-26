import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ruas_connect/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';
import 'package:ruas_connect/models/models.dart';
import 'package:ruas_connect/repository/respository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final String arenaName;
  final String courseCode;

  UploadBloc({@required String arenaName, @required String courseCode})
      : assert(arenaName != null, courseCode != null),
        arenaName = arenaName,
        courseCode = courseCode;

  @override
  UploadState get initialState => UploadFormState.empty();

  @override
  Stream<UploadState> transform(
      Stream<UploadEvent> events, Stream<UploadState> next(UploadEvent event)) {
    final observableStream = events as Observable<UploadEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TitleChanged && event is! DescriptionChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TitleChanged || event is DescriptionChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<UploadState> mapEventToState(
    UploadEvent event,
  ) async* {
    if (event is TitleChanged) {
      yield* _mapTitleChangedToState(event.title);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event.description);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        title: event.title,
        fileName: event.fileName,
        filePath: event.filePath,
        fileSize: event.fileSize,
        description: event.description,
      );
    }
  }

  /// Title will have a minimum of 5 and maximum of 30 characters
  /// Description will have a minimum of 5 and maximum of 120 characters

  Stream<UploadState> _mapTitleChangedToState(String title) async* {
    yield (currentState as UploadFormState)
        .update(isTitleValid: title.length > 5 && title.length < 20
//      Validators.isMinimumMaximumLengthText(title, 5, 30),
            );
  }

  Stream<UploadState> _mapDescriptionChangedToState(String description) async* {
    yield (currentState as UploadFormState).update(
        isDescriptionValid: description.length > 5 && description.length < 120
//          Validators.isMinimumMaximumLengthText(description, 5, 120),
        );
  }

  Stream<UploadState> _mapFormSubmittedToState({
    String title,
    String description,
    String fileName,
    String fileSize,
    String filePath,
  }) async* {
    try {
      yield UploadFormState.loading();
      final toUpload = UploadedFile(
        title: title,
        description: description,
        dateUploaded: DateTime.now(),
        filename: fileName,
        size: fileSize,
      );
      print('toUpload : { $toUpload }');
      await CoursesRepository.writeArenaFile(
        uploadedFile: toUpload,
        courseCode: this.courseCode,
        arena: this.arenaName,
        filePath: filePath,
      );
      yield UploadFormState.success();
    } catch (_) {
      yield UploadFormState.failure();
      yield UploadError(error: _.toString());
    }
  }
}
