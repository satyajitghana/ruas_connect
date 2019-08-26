import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruas_connect/authentication_bloc/bloc.dart';
import 'settings.dart';
import 'package:ruas_connect/models/models.dart';
import 'package:ruas_connect/repository/respository.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Settings'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            // If Edit is successful then refresh this page
            onPressed: () {
              UserDetails currentUser =
                  (BlocProvider.of<AuthenticationBloc>(context).currentState
                          as Authenticated)
                      .userDetails;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                        uid: currentUser.uid,
                        email: currentUser.email,
                        currentUser: currentUser,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Material(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ProfileDetails(
                currentUser: (BlocProvider.of<AuthenticationBloc>(context)
                        .currentState as Authenticated)
                    .userDetails,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: RaisedButton.icon(
                      color: Colors.blueAccent,
                      label: Text('Reset Password'),
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        UserRepository.resetPassword();

                        Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Reset Password Link Sent to your Email !'),
                                  Icon(
                                    Icons.done,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: RaisedButton.icon(
                      color: Colors.redAccent,
                      label: Text('Logout'),
                      icon: Icon(Icons.warning),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .dispatch(LoggedOut());
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final UserDetails currentUser;

  const ProfileDetails({Key key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey,
              ),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'assets/kitty.png',
                width: 160.0,
              ),
            ),
          ),
          Container(
            color: Colors.blueGrey,
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(currentUser.userName),
              subtitle: Text('Email : ${currentUser.email}'),
            ),
          ),
          Container(
            color: Colors.blueGrey,
            child: ListTile(
              leading: Icon(Icons.streetview),
              title: Text(currentUser.branch),
              subtitle: Text('Branch'),
            ),
          ),
          Container(
            color: Colors.blueGrey,
            child: ListTile(
              leading: Icon(Icons.assignment),
              title: Text(currentUser.semester),
              subtitle: Text('Semester'),
            ),
          ),
        ],
      ),
    );
  }
}
