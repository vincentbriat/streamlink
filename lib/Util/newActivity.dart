import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'categoryBuilder.dart';
import 'item.dart';

void newActivity(
    BuildContext context, String title, String collection, bool isItem,
    {FirebaseUser user, DocumentSnapshot document, String id}) {
  if (document == null && isItem) {
    Firestore.instance.collection(collection).document(id).get().then((doc) {
      document = doc;
      FirebaseAdMob.instance.initialize(
          appId: Platform.isIOS
              ? 'ca-app-pub-1881920148507968~7250131686'
              : 'ca-app-pub-1881920148507968~9121067810');
      InterstitialAd(
          adUnitId: Platform.isIOS
              ? 'ca-app-pub-1881920148507968/7058559998'
              : 'ca-app-pub-1881920148507968/3694030058')
        ..load()
        ..show();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return isItem
                ? Item(document, user, collection)
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      title: Text(title),
                      actions: <Widget>[
                        Icon(Icons.search),
                      ],
                    ),
                    body: CategoryBuilder(collection, 3, user),
                  );
          },
        ),
      );
    });
  } else {
    FirebaseAdMob.instance.initialize(
        appId: Platform.isIOS
            ? 'ca-app-pub-1881920148507968~7250131686'
            : 'ca-app-pub-1881920148507968~9121067810');
    InterstitialAd(
        adUnitId: Platform.isIOS
            ? 'ca-app-pub-1881920148507968/7058559998'
            : 'ca-app-pub-1881920148507968/3694030058')
      ..load()
      ..show();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return isItem
              ? Item(document, user, collection)
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: Text(title),
                    actions: <Widget>[
                      Icon(Icons.search),
                    ],
                  ),
                  body: CategoryBuilder(collection, 3, user),
                );
        },
      ),
    );
  }
}
