import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'favoritesList.dart';

class ConnectedBody extends StatelessWidget {
  final FirebaseUser _user;
  final DocumentReference userFromUsers;
  final ValueChanged<bool> switchIsConnected;

  ConnectedBody(this._user, this.userFromUsers, this.switchIsConnected);

  Widget title() {
    return FutureBuilder(
      future: userFromUsers.get().then((snap) => snap.data),
      initialData: {'username': ""},
      builder: (context, data) {
        return data.data['username'] == ''
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.only(top: 100, bottom: 100),
                          child: Text(
                            'Welcome ' + data.data["username"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FavoritesList(userFromUsers, _user),
                        Container(
                          padding: EdgeInsets.only(top: 100),
                          child: RaisedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              switchIsConnected(false);
                            },
                            color: Colors.white,
                            child: Text("Deconnexion"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return title();
  }
}
