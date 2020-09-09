import 'package:flutter/material.dart';
import 'forgottenPasswordBody.dart';

class ForgottenPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  100.0,
                  0,
                  150,
                ),
                child: Text(
                  "Mot De Passe Oublié ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: .8,
                    letterSpacing: 2.0,
                    color: Colors.white,
                    fontFamily: 'Monserrat',
                    fontSize: 55.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ForgottenPasswordBody()
            ],
          ),
        ));
  }
}
