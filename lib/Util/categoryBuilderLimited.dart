import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:StreamLink/Util/newActivity.dart';

class CategoryBuilderLimited extends StatelessWidget {
  final String _collection;
  final double _height;
  final FirebaseUser _user;

  CategoryBuilderLimited(this._collection, this._height, this._user);

  Widget _buildListItem(context, document) {
    return GridTile(
      child: SizedBox(
        child: GestureDetector(
          onTap: () => newActivity(context, document["name"], _collection, true,
              user: _user, document: document),
          child: Stack(
            children: [
              Container(
                width: 500,
              ),
              Center(
                child: Image.asset(
                  "assets/images/" +
                      document["name"].replaceAll(" ", "") +
                      ".jpg",
                  /*fit: BoxFit.cover*/
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection(_collection).limit(12).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return SizedBox(
          height: _height,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, snapshot.data.documents[index]);
            },
          ),
        );
      },
    );
  }
}

class CategoryBuilderLimitedOrderByFavorites extends StatelessWidget {
  final String _collection;
  final double _height;
  final FirebaseUser _user;

  CategoryBuilderLimitedOrderByFavorites(
      this._collection, this._height, this._user);

  Widget _buildListItem(context, document) {
    return GridTile(
      child: SizedBox(
        child: GestureDetector(
          onTap: () => Firestore.instance
              .collection(document["collection"])
              .document(document["id"])
              .get()
              .then(
                (doc) => newActivity(
                    context, doc["name"], document["collection"], true,
                    user: _user, document: doc),
              ),
          child: Stack(
            children: [
              Container(
                width: 500,
              ),
              Center(
                child: Image.asset(
                  "assets/images/" +
                      document["name"].replaceAll(" ", "") +
                      ".jpg",
                  /*fit: BoxFit.cover*/
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(_collection)
          .orderBy('favorites', descending: true)
          .limit(12)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return SizedBox(
          height: _height,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, snapshot.data.documents[index]);
            },
          ),
        );
      },
    );
  }
}
