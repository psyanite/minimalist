import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:minimalist/render/components/common/banners.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/privacy_screen.dart';
import 'package:minimalist/render/screens/terms_screen.dart';
import 'package:minimalist/utils/general_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _options(context),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              BurntBanner(image: null),
              Positioned(child: BackArrow(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _options(BuildContext context) {
    return SliverFillRemaining(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(padding: EdgeInsets.only(top: 25.0, left: 15.0, bottom: 10.0), child: Text('ABOUT', style: Themer().appBarTitleStyle())),
        ListTile(
          title: Text('Report an Issue', style: TextStyle(fontSize: 18.0)),
          onTap: () => _reportAnIssue(),
        ),
        ListTile(
          title: Text('Terms of Use', style: TextStyle(fontSize: 18.0)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsScreen())),
        ),
        ListTile(
          title: Text('Privacy Policy', style: TextStyle(fontSize: 18.0)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyScreen())),
        ),
      ]),
    );
  }

  _reportAnIssue() async {
    var deviceInfo = await Utils.getDeviceInfo();
    launch(Utils.buildEmail('Issue Report', '(describe-your-issue-here)\n\n\nDiagnostics\n\n$deviceInfo\n\n'));
  }
}
