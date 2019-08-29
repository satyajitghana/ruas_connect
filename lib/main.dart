import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ruas_connect/login/login.dart';
import 'package:ruas_connect/repository/respository.dart';
import 'package:ruas_connect/settings/bloc/bloc.dart';
import 'package:ruas_connect/settings/settings.dart';
import 'package:ruas_connect/simple_bloc_delegate.dart';
import 'package:ruas_connect/splash_screen.dart';
import 'main_arena.dart';

import 'authentication_bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();
  final CoursesRepository coursesRepository = CoursesRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<AuthenticationBloc>(
          builder: (BuildContext context) =>
              AuthenticationBloc(userRepository: userRepository)
                ..dispatch(AppStarted()),
        ),
        BlocProvider<SettingsBloc>(
          builder: (BuildContext context) =>
              SettingsBloc(userRepository: userRepository),
        ),
      ],
      child: App(
          userRepository: userRepository, courseRepository: coursesRepository),
    );
  }
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final CoursesRepository _coursesRepository;

  const App(
      {Key key,
      @required UserRepository userRepository,
      @required CoursesRepository courseRepository})
      : assert(userRepository != null),
        assert(courseRepository != null),
        _userRepository = userRepository,
        _coursesRepository = courseRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocBuilder(
        bloc: BlocProvider.of<AuthenticationBloc>(context),
        builder: (BuildContext context, AuthenticationState state) {
          if (state is Authenticated) {
            if (state.isEmailVerified) {
              return MainArenaPage();
            } else {
              return UnverifiedEmailScreen(
                  userRepository: _userRepository,
                  email: state.userDetails.email);
            }
          }
          if (state is Unauthenticated) {
            return LoginScreen(
              userRepository: _userRepository,
            );
          }
          // SetUserDetails is called only when Authenticated
          if (state is SetUserDetails) {
            return EditProfilePage(
              uid: state.uid,
              email: state.email,
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}

class UnverifiedEmailScreen extends StatelessWidget {
  final UserRepository userRepository;
  final String email;

  const UnverifiedEmailScreen({Key key, this.userRepository, this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Unverified Email'),
        ),
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text(
                    'Your email\n$email\nis unverified !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        Scaffold.of(scaffoldContext)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Sending Verification Email'),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          );
                        try {
                          await userRepository.sendVerificationEmail();
                        } catch (_) {
                          Scaffold.of(scaffoldContext)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('$_'),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            );
                        } finally {
                          Future.delayed(
                              const Duration(milliseconds: 2000),
                              () => BlocProvider.of<AuthenticationBloc>(context)
                                  .dispatch(AppStarted()));
                        }
                      },
                      child: Text('Send Verification Mail'),
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.warning),
                      color: Colors.red,
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .dispatch(LoggedOut());
                      },
                      label: Text('Log Out'),
                    )
                  ],
                ),
              ],
            );
          },
        ));
  }
}
