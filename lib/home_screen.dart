import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruas_connect/authentication_bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({Key key, this.name}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  String homeText = 'Loading . . .';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    rootBundle.loadString('assets/home_info.txt').then((text) => setState(() {
          homeText = text;
        }));

    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.blueGrey,
              child: Text(
                'Hello ${widget.name} 😀',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Colors.blueGrey,
              child: ListTile(
                leading: Image.asset('assets/network.png'),
                title: Text(
                  'Welcome To\nRUASConnect',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              color: Colors.blueGrey,
              child: Text(
                homeText,
                softWrap: true,
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
