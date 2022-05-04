import 'package:flutter/material.dart';

class SlideLeftRoute extends PageRouteBuilder {
  Widget page;
  Object? arguments;
  SlideLeftRoute({required this.page, this.arguments})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              page,
          settings: RouteSettings(
            arguments: arguments,
          ),
        );
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(animation),
      child: child,
    );
  }
}
