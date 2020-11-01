import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/main.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/services/firestore_service.dart';
import 'package:minimalist/state/app/app_reducer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';

class ResolveConflictScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ResolveConflictScreen({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          userData: userData,
          appstate: props.appstate,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final Map<String, dynamic> userData;
  final AppState appstate;
  final Function dispatch;

  const _Presenter({Key key, this.userData, this.appstate, this.dispatch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome,', style: TextStyle(fontSize: 50.0, fontWeight: Themer().fontBold())),
              Container(height: 10.0),
              Text('We found some app data in the cloud under your account, would you like to'),
              Container(height: 50.0),
              BottomButton(
                text: 'Use the app data in the cloud',
                onTap: () => showUseCloudDialog(context),
              ),
              Container(height: 20.0),
              InkWell(
                splashColor: Themer().splashPrimary(),
                highlightColor: Colors.transparent,
                onTap: () => showUseLocalDialog(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
                  child: Text('Destroy the data in the cloud and upload the current app data instead', textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0, color: Colors.blue)),
                ),
              )
            ],
          ),
        )
      )
    );
  }

  void showUseCloudDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Use Cloud Data',
          description: 'All boards, lists and todos currently in the app will be destroyed, and replaced with the data from the cloud',
          action: 'Use Cloud Data',
          onTap: () {
            dispatch(RefreshAppState(AppState.rehydrate(userData)));
            Navigator.pop(context);
            Navigator.popUntil(context, ModalRoute.withName(MainRoutes.home));
          },
        );
      },
    );
  }

  void showUseLocalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Destroy Cloud Data',
          description: 'All boards, lists and todos in the cloud will be destroyed.',
          action: 'Destroy Cloud Data',
          onTap: () {
            FirestoreService().saveState(appstate.toJson());
            Navigator.pop(context);
            Navigator.popUntil(context, ModalRoute.withName(MainRoutes.home));
          },
        );
      },
    );
  }
}

class _Props {
  final AppState appstate;
  final Function dispatch;

  _Props({
    this.appstate,
    this.dispatch,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      appstate: store.state,
      dispatch: (action) => store.dispatch(action),
    );
  }
}
