import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: SpinKitPulse(
                color: Colors.red,
                size: 400.0,
              ),
            ),
            Positioned(
              child: Image.asset(
                'assets/ruas_logo.png',
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
