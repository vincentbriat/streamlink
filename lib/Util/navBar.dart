import 'package:flutter/material.dart';
import 'package:StreamLink/Util/newActivity.dart';

class NavBar extends AppBar {
  NavBar(context)
      : super(
          backgroundColor: Colors.black,
          title: Row(
            children: _gestureDetector(context, ["Films", "Series", "Animes"]),
          ),
        );
}

List<Widget> _gestureDetector(BuildContext context, List<String> list) {
  List<Widget> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(
      Expanded(
          child: GestureDetector(
              onTap: () => newActivity(context, list[i], list[i], false),
              child: Center(child: Text(list[i])))),
    );
  }
  return result;
}
