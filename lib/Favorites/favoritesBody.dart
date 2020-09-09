import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:StreamLink/Favorites/signUp.dart';
import 'logIn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesBody extends StatefulWidget {
  final ValueChanged<Map> setUser;
  final ValueChanged<bool> switchIsConnected;

  FavoritesBody({this.setUser, this.switchIsConnected});

  @override
  _FavoritesBodyState createState() =>
      _FavoritesBodyState(setUser, switchIsConnected);
}

class _FavoritesBodyState extends State<FavoritesBody> {
  // 0 is Sign Up page, 1 is Log In page, 2 is the favorites page once you're connected
  int _whatToDisplay;
  final ValueChanged<Map<FirebaseUser, DocumentReference>> setUser;
  final ValueChanged<bool> switchIsConnected;

  _FavoritesBodyState(this.setUser, this.switchIsConnected);

  void _setWhatToDisplay(int whatToDisplay) {
    setState(() {
      _whatToDisplay = whatToDisplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_whatToDisplay) {
      case 1:
        return LogIn(_setWhatToDisplay, setUser, switchIsConnected);
      default:
        return SignUp(_setWhatToDisplay, setUser, switchIsConnected);
    }
  }
}
