import 'package:flutter/material.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/widgets/login_form.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatefulWidget {

  static const routeName = '/login';

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  BuildContext get context;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: Text('${model.appName}')),
          body: LoginFormAnimation(animation: animation,),
        );
      },
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
      child: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
  
}