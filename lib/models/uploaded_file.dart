class UploadedFile {
  final String title;
  final String description;
  final DateTime dateUploaded;
  String uploaderUsername;
  final String filename;
  final String size;
  String uploaderUid;

  UploadedFile(
      {this.title,
      this.description,
      this.dateUploaded,
      this.uploaderUsername,
      this.filename,
      this.size,
      this.uploaderUid});

  @override
  String toString() => '''{ Title : $title,
  Description : $description,
  DateUploaded : $dateUploaded,
  UploaderUsername : $uploaderUsername,
  FileName : $filename,
  Size : $size,
  UploaderUid : $uploaderUid,
  }''';

  Map<String, dynamic> toJSON() {
    return {
      'title': title,
      'description': description,
      'dateUploaded': dateUploaded,
      'uploaderUsername': uploaderUsername,
      'filename': filename,
      'size': size,
      'uploaderUid': uploaderUid
    };
  }
}
