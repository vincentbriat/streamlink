import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:StreamLink/Util/newActivity.dart';

class CategoryBuilder extends StatelessWidget {
  final String collection;
  final int numberOfColumns;
  final FirebaseUser _user;

  CategoryBuilder(this.collection, this.numberOfColumns, this._user);

  Widget _buildListItem(context, document) {
    return GridTile(
      child: SizedBox(
        width: 500.0,
        child: GestureDetector(
          onTap: () => newActivity(context, document["name"], collection, true,
              user: _user, document: document),
          child: Center(
            child: Image.asset(
                "assets/images/" +
                    document["name"].replaceAll(" ", "") +
                    ".jpg",
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: StreamBuilder(
        stream: Firestore.instance.collection(collection).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberOfColumns),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }
}
