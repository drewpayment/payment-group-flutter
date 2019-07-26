
import 'package:flutter/material.dart';

class CustomBottomSheet {

  static Future<T> showScrollingModalBottomSheet<T>({
    @required BuildContext context,
    bool isScrollControlled = true,
    ShapeBorder shape,
    double heightPercView = 0.95,
    double topMargin = 65.0,
    @required Widget appBar,
    @required Widget child,
  }) {
    final br = BorderRadius.circular(50);
    shape = shape != null ? shape
      : RoundedRectangleBorder(borderRadius: br);
    return showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      context: context,
      shape: shape,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * heightPercView,
          decoration: BoxDecoration(borderRadius: br),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(topMargin),
              child: appBar,
            ),
            body: child,
          ),
        );
      }
    );
  }

}