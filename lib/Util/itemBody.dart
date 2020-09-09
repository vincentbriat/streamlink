import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';

import 'ArrayToEntryTrees.dart';

class ItemBody extends StatefulWidget {
  final DocumentSnapshot document;
  final FirebaseUser _user;
  final String collection;

  ItemBody(this.document, this._user, this.collection);

  @override
  _ItemBodyState createState() => _ItemBodyState(document, _user, collection);
}

class _ItemBodyState extends State<ItemBody> {
  final DocumentSnapshot document;
  final FirebaseUser _user;
  final String collection;
  bool isFavorite = false;

  _ItemBodyState(this.document, this._user, this.collection);

  void updateFavorite(context) {
    if (_user == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Connectez-vous pour sauvegarder vos favoris'),
          action: SnackBarAction(
            label: 'FERMER',
            onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    } else {
      if (!isFavorite) {
        Firestore.instance
            .collection('Users')
            .document(_user.uid)
            .collection('favorites')
            .document(collection)
            .setData({
          document.documentID: document['name'],
        }, merge: true);
        Firestore.instance
            .collection('Titles')
            .where('id', isEqualTo: document.documentID)
            .getDocuments()
            .then(
              (snap) => snap.documents.forEach((doc) {
                doc.reference
                    .updateData({'favorites': doc.data['favorites'] + 1});
              }),
            );
        setState(() {
          isFavorite = !isFavorite;
        });
      } else {
        Firestore.instance
            .collection('Users')
            .document(_user.uid)
            .collection('favorites')
            .document(collection)
            .updateData(
          {
            document.documentID: FieldValue.delete(),
          },
        );
        Firestore.instance
            .collection('Titles')
            .where('id', isEqualTo: document.documentID)
            .getDocuments()
            .then((snap) => snap.documents.forEach((doc) => doc.reference
                .updateData({'favorites': doc.data['favorites'] - 1})));
        setState(() {
          isFavorite = !isFavorite;
        });
      }
    }
  }

  void getFavorites() {
    if (_user != null) {
      Firestore.instance
          .collection('Users')
          .document(_user.uid)
          .collection('favorites')
          .document(collection)
          .get()
          .then(
            (snap) => setState(
                () => isFavorite = snap.data[document.documentID] != null),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    getFavorites();
    return Center(
      child: Stack(
        children: [
          Container(
            child: Image.asset("assets/images/" +
                document.data["name"].replaceAll(" ", "") +
                ".jpg"),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0,
                        child: Container(
                          height: 600.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(45.0, 30, 45.0, 45.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 50.0),
                            child: Text(
                              "Synopsis",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  decoration: TextDecoration.none,
                                  color: Colors.white),
                            ),
                          ),
                          Text(
                            document["description"],
                            style: TextStyle(
                                fontSize: 14.0,
                                decoration: TextDecoration.none,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ]),
              ),
              SliverGroupBuilder(
                decoration: BoxDecoration(color: Colors.black),
                child: SliverPadding(
                  padding: EdgeInsets.all(30.0),
                  sliver: SliverList(
                    delegate: collection == 'Series'
                        ? SliverChildBuilderDelegate(
                            (context, index) => arrayToEntryTreeSeries(
                                context, index, document["seasons"]),
                            childCount: document["seasons"].length,
                          )
                        : SliverChildBuilderDelegate(
                            (context, index) => arrayToEntryTreeLinks(
                                context, index, document["links"]),
                            childCount: document["links"].length,
                          ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 25.0,
            right: 25.0,
            child: GestureDetector(
              onTap: () => updateFavorite(context),
              child: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.redAccent[700] : Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
