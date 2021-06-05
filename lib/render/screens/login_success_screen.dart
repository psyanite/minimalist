import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/services/auth_service.dart';

class LoginSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = AuthService().getUser();
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.only(left: 30.0, top: 50.0), child: BackArrow()),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🎉 Success! Your data is now safe in the cloud.'),
                    Container(height: 20.0),
                    NetworkImg(user.photoURL, width: 100.0, height: 100.0),
                    Container(height: 20.0),
                    Text(user.email),
                    Container(height: 30.0),
                    Text('Any changes from now on will be automatically synced to the cloud.', textAlign: TextAlign.center),
                    Container(height: 20.0),
                    Text('Happy Todoing!'),
                    Container(height: 40.0),
                  ],
                ),
                Container(height: 70.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
