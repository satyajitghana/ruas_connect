import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

class UploadRepository {
  final FirebaseStorage _storageRef;

  UploadRepository(FirebaseStorage storageRef)
      : assert(storageRef != null),
        _storageRef = storageRef;

  Future<void> uploadDocument(
      {String filename,
      Map<String, String> metadata,
      String filePath,
      String uploadLocationWithFileName}) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(uploadLocationWithFileName);
    File toUpload = File(filePath);
    final StorageUploadTask storageUploadTask = storageReference.putFile(
        toUpload,
        StorageMetadata(
            contentType: 'application/pdf', customMetadata: metadata));
    await storageUploadTask.onComplete;
  }
}
