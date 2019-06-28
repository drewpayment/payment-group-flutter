import 'package:flutter/material.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/widgets/login_form.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  kiwi.Container container = kiwi.Container();
  ConfigModel config;

  LoginPageState() {
    config = container.resolve<ConfigModel>();
  }

  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          color: Theme.of(context).primaryColor.withOpacity(0.30),
        )
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.45),
        appBar: CustomAppBar(title: Text('${config.appName}')),
        body: LoginFormAnimation(animation: animation),
      ),
    );
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

}

class LoginFormAnimation extends AnimatedWidget {
  LoginFormAnimation({Key key, Animation<double> animation})
    : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return FadeTransition(
      opacity: animation,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LoginForm(),
          ],
        ),
      ),
    );
  }
  
}