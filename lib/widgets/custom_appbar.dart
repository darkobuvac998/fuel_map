import 'package:flutter/material.dart';

import '../screens/gas_stations_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  String title;
  List<Widget>? actions;
  bool? automaticallyImplyLeading;
  CustomAppBar({
    required this.title,
    this.actions,
    this.automaticallyImplyLeading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xfff8be32),
              Color(0xffea5e29),
            ],
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
