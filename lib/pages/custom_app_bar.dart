import 'package:flutter/material.dart';
import 'package:rebuilder/rebuilder.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({ Key key, Widget title, List<Widget> actions })
    : super(key: key, title: title, actions: actions);
}

class AppBarModel extends DataModel {
  Key key;
  Widget title;
  List<Widget> actions;

  AppBarModel({ @required this.title, this.key, this.actions });

  final keyState = StateWrapper();
  final titleState = StateWrapper();
  final actionsState = StateWrapper();

  updateTitle(Widget value) {
    if (value == null) return;
    title = value;
    titleState.rebuild();
  }

  @override
  dispose() {}
}