import 'package:flutter/material.dart';

Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: 800),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    },
  );
}
