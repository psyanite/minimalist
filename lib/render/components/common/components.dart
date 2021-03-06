import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minimalist/render/presentation/crust_cons_icons.dart';
import 'package:minimalist/render/presentation/themer.dart';

class SolidBackButton extends StatelessWidget {
  final Color color;
  final Color textColor;

  SolidBackButton({
    Key key,
    this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Themer().primary();
    final textColor = this.textColor ?? Themer().white();
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: EdgeInsets.only(left: 7.0, right: 13.0, top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), color: color),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Icon(Icons.arrow_back_ios, color: textColor, size: 20.0),
          Container(width: 3.0),
          Text('Go Back', style: TextStyle(color: textColor, fontSize: 22.0))
        ]),
      ),
    );
  }
}

class WhiteBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SolidBackButton(color: Colors.white, textColor: Themer().primary());
  }
}

class BackArrow extends StatelessWidget {
  final Color color;

  BackArrow({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Themer().lightGrey();
    return IconButton(
      icon: Icon(CrustCons.back, color: color, size: 30.0),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class SmallButton extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;
  final Color color;

  SmallButton({
    Key key,
    this.child,
    this.onTap,
    this.padding,
    this.gradient,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = this.gradient ?? Themer().buttonGradient();
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
          gradient: color != null ? null : gradient,
          color: color,
        ),
        child: child,
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  final Widget child;
  final String text;
  final Function onPressed;

  WhiteButton({
    Key key,
    this.child,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Themer().splashPrimary(),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            boxShadow: [
              BoxShadow(color: Color(0x10000000), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 1.0)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[_content()],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    if (child != null) return child;
    return Text(text, style: TextStyle(fontSize: 20.0, color: Themer().primary()));
  }
}

class BottomButton extends StatelessWidget {
  final String text;
  final Function onTap;

  BottomButton({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
          gradient: Themer().buttonGradient(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class BurntButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final Function onTap;
  final double padding;
  final double fontSize;
  final Color color;

  BurntButton({
    Key key,
    this.icon,
    this.iconSize,
    this.text,
    this.onTap,
    this.padding,
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: padding ?? 20.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), color: color ?? Themer().primary()),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (icon != null) Icon(icon, size: iconSize ?? 20.0, color: Colors.white),
            if (icon != null) Container(width: 8.0),
            Text(text, style: TextStyle(fontSize: fontSize ?? 22.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class SolidButton extends StatelessWidget {
  final Function onTap;
  final List<Widget> children;
  final EdgeInsets padding;
  final Color color;
  final Color splashColor;

  SolidButton({
    Key key,
    this.onTap,
    this.children,
    this.padding,
    this.color,
    this.splashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor ?? Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(2.0),
        ),
        padding: padding ?? EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class HollowButton extends StatelessWidget {
  final Function onTap;
  final List<Widget> children;
  final EdgeInsets padding;
  final Color borderColor;
  final Color splashColor;

  HollowButton({
    Key key,
    this.onTap,
    this.children,
    this.padding,
    this.borderColor,
    this.splashColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor ?? Themer().splashPrimary(),
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.blue, width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(2.0),
        ),
        padding: padding ?? EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class LoadingCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CircularProgressIndicator(),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x99000000),
      body: LoadingCenter(),
    );
  }
}

class SliverCenter extends StatelessWidget {
  final Widget child;

  SliverCenter({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class LoadingSliverCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverCenter(
      child: CircularProgressIndicator(),
    );
  }
}

class LoadingSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Container(height: 200, child: Center(child: CircularProgressIndicator())));
  }
}

class CenterTextSliver extends StatelessWidget {
  final String text;

  CenterTextSliver({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Text(text, style: TextStyle(fontSize: 17.0), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class HeaderSliver extends StatelessWidget {
  final String title;

  const HeaderSliver({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 35.0, bottom: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(left: -12.0, child: BackArrow()),
              ],
            ),
            if (title != null) Text(title, style: Themer().appBarTitleStyle())
          ]),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;

  const Header({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 35.0, bottom: 20.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(width: 50.0, height: 60.0),
                  Positioned(left: -12.0, child: BackArrow()),
                ],
              ),
              if (title != null) Text(title, style: Themer().appBarTitleStyle())
            ]),
          ),
        ],
      ),
    );
  }
}

class CleanScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HeartIcon extends StatelessWidget {
  final bool isHollow;
  final double size;

  HeartIcon({
    Key key,
    this.isHollow,
    this.size = 25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var assetName = isHollow ? 'assets/svgs/heart-hollow.svg' : 'assets/svgs/heart-filled.svg';
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
    );
  }
}

class NetworkImg extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxFit fit;

  NetworkImg(
    this.url, {
    Key key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url.isEmpty) {
      return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        color: Themer().imgPlaceholderColor(),
      );
    }
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Themer().imgPlaceholderColor(),
        image: DecorationImage(image: CachedNetworkImageProvider(url), fit: BoxFit.cover),
      ),
    );
  }
}

class ModalWrapper extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  final int width;

  const ModalWrapper({Key key, this.children, this.padding, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
      child: Container(
        padding: padding ?? EdgeInsets.only(top: 20.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

buttonSnack(BuildContext context, String text, String buttonText, Function onTap) {
  final snackBar = SnackBar(
    elevation: 0.0,
    backgroundColor: Color(0xFF51A4FF),
    content: Container(
      height: 70.0,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(text, style: TextStyle(color: Color(0xEEFFFFFF), fontSize: 18.0))),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.only(left: 8.0, top: 2.0, bottom: 2.0),
              child: Text(
                buttonText,
                style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: Themer().fontBold()),
              ),
            ),
          )
        ],
      ),
    ),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

snack(BuildContext context, String text) {
  buttonSnack(context, text, 'OK', () {
    Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  });
}

snackError(BuildContext context) {
  var text = 'Oops! Something went wrong, please try again';
  buttonSnack(context, text, 'OK', () {
    Scaffold.of(context).removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  });
}
