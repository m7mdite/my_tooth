import 'package:flutter/material.dart';

class AppThemeConstants {
  static const BorderRadiusGeometry borderRadius = BorderRadius.only(
    topLeft: Radius.elliptical(100, 10),
    bottomLeft: Radius.elliptical(10, 100),
    topRight: Radius.elliptical(10, 100),
    bottomRight: Radius.elliptical(100, 10),
  );
}