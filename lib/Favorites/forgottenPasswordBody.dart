import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgottenPasswordBody extends StatefulWidget {
  @override
  _ForgottenPasswordBodyState createState() => _ForgottenPasswordBodyState();
}

class _ForgottenPasswordBodyState extends State<ForgottenPasswordBody> {
  String _email = "";

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Un mail de récuperation de mot de passe vient de vous être envoyé à l\'adresse $email.',
          ),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'FERMER',
            onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Utilisateur introuvable. Veuillez vérifiez l\'adresse email renseignée.',
          ),
          duration: Duration(seconds: 6),
          action: SnackBarAction(
            label: 'FERMER',
            onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 60),
          child: TextField(
            onChanged: (text) {
              setState(() {
                _email = text;
              });
            },
            onSubmitted: resetPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.redAccent[700],
                ),
              ),
              labelText: " EMAIL",
              labelStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Monserrat',
                  fontWeight: FontWeight.bold),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(30.0, 0, 30.0, 20.0),
          height: 40.0,
          child: Material(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey[100],
            shadowColor: Colors.grey[100],
            elevation: 2.0,
            child: GestureDetector(
              onTap: () {
                resetPassword(
                  _email,
                );
              },
              child: Center(
                child: Text(
                  "CONFIRMER",
                  style: TextStyle(
                      color: Colors.redAccent[700],
                      fontSize: 18.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
