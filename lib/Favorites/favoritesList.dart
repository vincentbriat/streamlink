import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:StreamLink/Util/newActivity.dart';

class FavoritesList extends StatelessWidget {
  final DocumentReference userData;
  final FirebaseUser _user;

  FavoritesList(this.userData, this._user);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userData.collection('favorites').getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
                children: snapshot.data.documents.map<Widget>((document) {
              return ExpansionTile(
                title: Text(
                  document.documentID,
                  style: TextStyle(color: Colors.white),
                ),
                children: document.data.entries
                    .map<Widget>(
                      (e) => ListTile(
                        title: Image.asset(
                          "assets/images/" +
                              e.value.replaceAll(" ", "") +
                              ".jpg",
                          fit: BoxFit.scaleDown,
                          height: 250.0,
                        ),
                        onTap: () {
                          newActivity(
                              context, e.value, document.documentID, true,
                              user: _user, id: e.key);
                        },
                      ),
                    )
                    .toList(),
              );
            }).toList());
          }
        });
  }
}
