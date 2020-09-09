import 'package:flutter/material.dart';

class TitleDiscoveryBody extends StatelessWidget {
  final String title;

  TitleDiscoveryBody(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }
}
