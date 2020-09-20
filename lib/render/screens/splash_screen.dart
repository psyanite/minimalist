import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/main.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    _redirect();
  }

  _redirect() async {
    Timer(Duration(milliseconds: 500), () {
      Navigator.popAndPushNamed(context, MainRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
      onInit: (Store<AppState> store) async {
        var settings = store.state.settings;
        Themer().init(settings.themeChoice, settings.fontChoice, settings.contentAlign);
      },
      converter: (Store<AppState> store) => 1,
      builder: (BuildContext context, int props) {
        return _presenter();
      },
    );
  }

  Widget _presenter() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: Themer().burntGradient()),
        child: Center(
          child: Image.asset('assets/images/loading-icon.png', height: 200.0),
        ),
      ),
    );
  }
}
