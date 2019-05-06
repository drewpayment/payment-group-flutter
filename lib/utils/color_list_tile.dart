import 'package:flutter/material.dart';

class ColorListTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Function onTap;
  bool enabled = true;
  bool selected = false;
  final EdgeInsetsGeometry contentPadding;

  ColorListTile(this.leading, this.title, this.subtitle, this.onTap, this.contentPadding, this.enabled, this.selected);

  @override
  ColorListTileState createState() => ColorListTileState(leading, title, subtitle, onTap, contentPadding, enabled, selected);
}

class ColorListTileState extends State<ColorListTile> {
  final Widget leading;
  final Widget customTitle;
  final Widget subtitle;
  final Function onTap;
  final bool enabled;
  final bool selected;
  final EdgeInsetsGeometry contentPadding;
  Color color;

  ColorListTileState(
    this.leading, 
    this.customTitle, 
    this.subtitle, 
    this.onTap, 
    this.contentPadding,
    this.enabled, 
    this.selected,
  );

  @override
  void initState() {
    super.initState();
    color = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: ListTile(
        leading: leading,
        title: customTitle,
        onTap: onTap,
        selected: selected,
        enabled: enabled,
      ),
    );
  }
}