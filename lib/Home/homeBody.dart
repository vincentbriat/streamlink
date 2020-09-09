import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'searchResults.dart';

class HomeBody extends StatefulWidget {
  final FirebaseUser user;

  HomeBody({this.user});

  @override
  _HomeBody createState() => _HomeBody(user);
}

class _HomeBody extends State<HomeBody> {
  List _titles = [];
  List _filteredTitles = [];
  bool _readOnly = true;
  FirebaseUser _user;

  _HomeBody(_user) {
    this._user = _user;
    updateTitles();
  }

  void updateTitles() {
    Firestore.instance.collection('Titles').getDocuments().then(
          (snap) => snap.documents.forEach(
            (doc) => _titles.add(
              doc.data,
            ),
          ),
        );
  }

  void handleSearchChange(String mot) {
    setState(
      () {
        _filteredTitles = [];
        mot.replaceAll(' ', '') == ''
            ? _filteredTitles = []
            : _titles.forEach(
                (title) {
                  title["name"].toLowerCase().contains(mot.toLowerCase())
                      ? _filteredTitles.add(title)
                      : null;
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      readOnly: _readOnly,
                      onTap: () {
                        _titles.length == 0
                            ? Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Data updating..."),
                                  action: SnackBarAction(
                                    label: 'FERMER',
                                    onPressed: Scaffold.of(context)
                                        .hideCurrentSnackBar,
                                  ),
                                ),
                              )
                            : setState(() => _readOnly = false);
                      },
                      onChanged: handleSearchChange,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 4.0),
                          hintText: "Rechercher votre Film/Série/Animé"),
                    ),
                  ),
                  Icon(Icons.search)
                ],
              ),
            ),
          ),
          SearchResults(_filteredTitles, _user)
        ],
      ),
    );
  }
}
