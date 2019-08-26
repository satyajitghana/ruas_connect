import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'messages.dart';
import 'package:ruas_connect/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:ruas_connect/authentication_bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class MessagesScreen extends StatefulWidget {
  final String branch, semester;

  const MessagesScreen({Key key, this.branch, this.semester}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with AutomaticKeepAliveClientMixin<MessagesScreen> {
  TextEditingController _textEditingController;
  bool _isComposingMessage;

  DatabaseReference _reference;

  UserDetails currentUser;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _isComposingMessage = false;
    currentUser = (BlocProvider
        .of<AuthenticationBloc>(context)
        .currentState
    as Authenticated)
        .userDetails;
    _reference = FirebaseDatabase.instance.reference().child(
        '${widget.branch}/${widget.semester}/messages');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: _reference,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              sort: (a, b) => b.key.compareTo(a.key),
              itemBuilder: (_, DataSnapshot messageSnapshot,
                  Animation<double> animation, int index) {
                print(messageSnapshot.value);
                return MessageListItem(
                  messageSnapshot: messageSnapshot,
                  animation: animation,
                  currentUserEmail: currentUser.email,
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: new BoxDecoration(color: Theme
                .of(context)
                .cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(
        color: _isComposingMessage
            ? Theme
            .of(context)
            .accentColor
            : Theme
            .of(context)
            .disabledColor,
      ),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(
                    Icons.photo_camera,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () async {
                    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
                    int timestamp = new DateTime.now().millisecondsSinceEpoch;
                    StorageReference storageReference = FirebaseStorage
                        .instance
                        .ref()
                        .child("chat/img_" + timestamp.toString() + ".jpg");
                    StorageUploadTask uploadTask =
                    storageReference.put(imageFile);
                    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
                    _sendMessage(
                        messageText: null, imageUrl: downloadUrl);
                  }),
            ),
            Flexible(
              child: new TextField(
                controller: _textEditingController,
                onChanged: (String messageText) {
                  setState(() {
                    _isComposingMessage = messageText.length > 0;
                  });
                },
                onSubmitted: _textMessageSubmitted,
                decoration:
                InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: getDefaultSendButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    _reference.push().set({
      'text': messageText,
      'email': currentUser.email,
      'senderName': currentUser.userName,
      'imageUrl': imageUrl,
    });
  }

  @override
  bool get wantKeepAlive => true;
}
