import 'package:flutter/material.dart';

class ColorListTile extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Function onTap;
  bool enabled = true;
  bool selected = false;
  final EdgeInsetsGeometry contentPadding;
  final Color selectedColor;

  ColorListTile({this.leading, this.title, this.subtitle, this.onTap, 
    this.contentPadding, this.enabled, this.selected, this.selectedColor
  });

  @override
  ColorListTileState createState() => ColorListTileState(leading, title, subtitle, onTap, contentPadding, enabled, selected, selectedColor);
}

class ColorListTileState extends State<ColorListTile> {
  final Widget leading;
  final Widget customTitle;
  final Widget subtitle;
  final Function onTapDelegate;
  bool enabled = true;
  bool selected = false;
  final EdgeInsetsGeometry contentPadding;
  Color color;
  final Color baseColor = Colors.transparent;
  final Color selectedColor;

  ColorListTileState(
    this.leading, 
    this.customTitle, 
    this.subtitle, 
    this.onTapDelegate, 
    this.contentPadding,
    this.enabled, 
    this.selected,
    this.selectedColor
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
        onTap: () {
          setState(() {
            selected = !selected;
            color = selected ? selectedColor : baseColor;
          });
          onTapDelegate(selected);
        },
        selected: selected,
        enabled: true,
      ),
    );
  }
}