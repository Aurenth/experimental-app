import 'package:flutter/material.dart';

/// Border radius tokens for the Muhurtam design system.
abstract final class AppRadii {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xl2 = 32;
  static const double full = 9999; // pill / circular

  // Convenience BorderRadius constants
  static const BorderRadius noneAll = BorderRadius.zero;
  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xl2All = BorderRadius.all(Radius.circular(xl2));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}
