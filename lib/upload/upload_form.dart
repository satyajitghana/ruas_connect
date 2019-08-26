import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruas_connect/upload/bloc/bloc.dart';
import 'package:ruas_connect/models/models.dart';

class UploadForm extends StatefulWidget {
  final String filePath;

  const UploadForm({Key key, this.filePath}) : super(key: key);

  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  UploadBloc _uploadBloc;

  bool get isPopulated =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  bool isUploadButtonEnabled(UploadFormState state) {
    return isPopulated && state.isFormValid && !state.isSubmitting;
  }

  String fileSize;
  String fileName;

  @override
  void initState() {
    super.initState();
    _uploadBloc = BlocProvider.of<UploadBloc>(context);
    _titleController.addListener(_onTitleChanged);
    _descriptionController.addListener(_onDescriptionChanged);

    File file = File(widget.filePath);

    fileSize = '${(file.lengthSync() * 1e-3).toStringAsFixed(2)} kB';
    fileName = Path.basename(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _uploadBloc,
      listener: (BuildContext context, UploadState state) {
        if (state is UploadError) {
          /// Create a New Window With the displayed Error
        }
        if (state is UploadFormState) {
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Uploading, please wait ...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Uploaded Successfully !'),
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              );
            Navigator.pop(context, true);
          }
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Registration Failure'),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        }
      },
      child: BlocBuilder(
          bloc: _uploadBloc,
          builder: (BuildContext context, UploadState state) {
            return Container(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          spacing: 12.0,
                          children: <Widget>[
                            Image.asset(
                              'assets/pdf.png',
                              width: 150.0,
                            ),
                            Container(
                              width: 180.0,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.white70, width: 2.0),
                                ),
                              ),
                            ),
                            Text('File: $fileName '),
                            Text('Size : $fileSize ')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            controller: _titleController,
                            maxLength: 30,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon: Icon(Icons.title),
                              labelText: 'Title',
                            ),
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            keyboardType: TextInputType.multiline,
                            maxLength: 120,
                            maxLines: 4,
                            decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                labelText: 'Description'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80.0, vertical: 30.0),
                            child: RaisedButton.icon(
                              onPressed: isUploadButtonEnabled(state)
                                  ? _onFormSubmitted
                                  : null,
                              icon: Icon(Icons.file_upload),
                              label: Text('Upload'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void _onTitleChanged() {
    _uploadBloc.dispatch(
      TitleChanged(title: _titleController.text),
    );
  }

  void _onDescriptionChanged() {
    _uploadBloc.dispatch(
      DescriptionChanged(description: _descriptionController.text),
    );
  }

  void _onFormSubmitted() {
    _uploadBloc.dispatch(
      Submitted(
          title: _titleController.text,
          description: _descriptionController.text,
          fileName: fileName,
          fileSize: fileSize,
          filePath: widget.filePath),
    );
  }
}
