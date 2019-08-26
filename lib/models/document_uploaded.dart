class DocumentUploaded {
  String arenaName;
  String courseCode;
  String description;
  String fileName;
  String size;
  String timeCreated;
  String title;
  String uploaderUid;
  String uploaderUsername;
  String uuid;
  Map<dynamic, dynamic> stats;
  String uploadLocation;

  DocumentUploaded({Map<String, dynamic> document}) {
    this.arenaName = document['arenaName'];
    this.courseCode = document['courseCode'];
    this.description = document['description'];
    this.fileName = document['fileName'];
    this.size = document['size'];
    this.timeCreated = document['timeCreated'];
    this.title = document['title'];
    this.uploaderUid = document['uploaderUid'];
    this.uploaderUsername = document['uploaderUsername'];
    this.uuid = document['uuid'];
    this.stats = document['stats'];
    this.uploadLocation = document['uploadLocation'];
  }
}
