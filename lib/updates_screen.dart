import 'package:flutter/material.dart';

class UpdatesScreen extends StatefulWidget {
  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen>
    with AutomaticKeepAliveClientMixin<UpdatesScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            elevation: 15.0,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Alpha Release',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          DeveloperInfo(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.blue,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Buy Me Coffee 😛',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                subtitle: Image.asset('assets/paytm_qr.jpg'),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BuyMeCoffeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Me Coffee'),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.blueGrey,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Developer Info',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/shadowleaf.png'),
              ),
              title: Text(
                'shadowleaf.satyajit',
                style: TextStyle(fontSize: 20.0),
              ),
              subtitle: Text('Developer'),
            ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/gmail.png'),
              ),
              title: Text(
                'shadowleaf.satyajit@gmail.com',
                style: TextStyle(fontSize: 15.0),
              ),
              subtitle: Text('Gmail'),
            ),
          ],
        ),
      ),
    );
  }
}
