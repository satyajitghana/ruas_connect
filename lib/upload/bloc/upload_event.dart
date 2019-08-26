import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ruas_connect/models/models.dart';

@immutable
abstract class UploadEvent extends Equatable {
  UploadEvent([List props = const []]) : super(props);
}

class TitleChanged extends UploadEvent {
  final String title;

  TitleChanged({@required this.title}) : super([title]);

  @override
  String toString() => 'TitleChanged { title : $title }';
}

class DescriptionChanged extends UploadEvent {
  final String description;

  DescriptionChanged({@required this.description}) : super([description]);

  @override
  String toString() => 'DescriptionChanged { description : $description }';
}

class Submitted extends UploadEvent {
  final String title, description, fileName, fileSize, filePath;

  Submitted({
    @required this.title,
    @required this.description,
    @required this.fileName,
    @required this.fileSize,
    @required this.filePath,
  }) : super([
          title,
          description,
          fileName,
          fileSize,
          filePath,
        ]);

  @override
  String toString() => '''Submitted { title: $title,
  description : $description,
  fileName : $fileName,
  fileSize : $fileSize,
  filePath : $filePath}''';
}

class StartUpload extends UploadEvent {
  final UploadedFile uploadedFile;

  StartUpload({@required this.uploadedFile}) : super([uploadedFile]);

  @override
  String toString() => 'StartUpload { uploadedFile : $uploadedFile }';
}
