import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/main.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/services/auth_service.dart';

class AccountScreen extends StatelessWidget {
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
                    NetworkImg(user.photoURL, width: 100.0, height: 100.0),
                    Container(height: 20.0),
                    Text(user.email),
                    Container(height: 30.0),
                    InkWell(
                      splashColor: Themer().splashPrimary(),
                      highlightColor: Colors.transparent,
                      onTap: () => showLogoutDialog(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                        child: Text('Logout', textAlign: TextAlign.center, style: TextStyle(fontSize: 22.0, color: Themer().anchorColor())),
                      ),
                    )
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

  void showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Logout',
          description: 'Would you like to logout of minimalist?',
          action: 'Logout',
          onTap: () async {
            var success = await AuthService().signOut();
            if (success) {
              Navigator.pop(context);
              Navigator.popUntil(context, ModalRoute.withName(MainRoutes.home));
            } else {
              Navigator.pop(context);
              snackError(parentContext);
            }
          },
        );
      },
    );
  }
}
