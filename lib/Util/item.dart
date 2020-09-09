import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'itemBody.dart';

class Item extends StatelessWidget {
  final DocumentSnapshot document;
  final FirebaseUser _user;
  final String collection;

  Item(this.document, this._user, this.collection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ItemBody(document, _user, collection));
  }
}
