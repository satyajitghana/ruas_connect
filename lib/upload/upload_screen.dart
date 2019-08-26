import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruas_connect/upload/bloc/bloc.dart';

import 'upload.dart';

class UploadScreen extends StatelessWidget {
  final String filePath;
  final String arenaName;
  final String courseCode;

  const UploadScreen(
      {Key key,
      this.filePath,
      @required this.arenaName,
      @required this.courseCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('UploadScreen => arenaName : $arenaName, courseCode : $courseCode');

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Files'),
      ),
      body: Center(
        child: BlocProvider<UploadBloc>(
          builder: (context) =>
              UploadBloc(arenaName: arenaName, courseCode: courseCode),
          child: UploadForm(
            filePath: filePath,
          ),
        ),
      ),
    );
  }
}
