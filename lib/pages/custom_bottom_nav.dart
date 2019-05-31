
import 'package:flutter/material.dart';

class CustomBottomNav extends BottomNavigationBar {

  CustomBottomNav({ List<BottomNavigationBarItem> items, int currentIndex, ValueChanged<int> onTap }) 
    : super(items: items, currentIndex: currentIndex, onTap: onTap);
}