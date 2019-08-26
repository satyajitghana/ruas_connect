import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String currentUserEmail;

  const MessageListItem(
      {Key key, this.messageSnapshot, this.animation, this.currentUserEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: currentUserEmail == messageSnapshot.value['email']
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(messageSnapshot.value['senderName'],
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.value['imageUrl'] != null
                  ? Image.network(
                      messageSnapshot.value['imageUrl'],
                      width: 250.0,
                    )
                  : Text(messageSnapshot.value['text']),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(messageSnapshot.value['senderName'],
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.value['imageUrl'] != null
                  ? new Image.network(
                      messageSnapshot.value['imageUrl'],
                      width: 250.0,
                    )
                  : Text(messageSnapshot.value['text']),
            ),
          ],
        ),
      ),
    ];
  }
}
