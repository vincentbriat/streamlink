import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Util/newActivity.dart';

class SearchResults extends StatelessWidget {
  final List _filteredTitles;
  final FirebaseUser _user;

  SearchResults(this._filteredTitles, this._user);

  Widget _buildQueryGrid(BuildContext context, int index) {
    return GridTile(
      child: GestureDetector(
        onTap: () {
          newActivity(context, _filteredTitles[index]["name"],
              _filteredTitles[index]["collection"], true,
              user: _user, id: _filteredTitles[index]["id"]);
        },
        child: Stack(
          children: [
            Container(
              color: Colors.grey[900],
            ),
            Center(
              child: Image.asset(
                  "assets/images/" +
                      _filteredTitles[index]["name"].replaceAll(" ", "") +
                      ".jpg",
                  fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _filteredTitles.length > 0
        ? Expanded(
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: _filteredTitles.length,
              itemBuilder: _buildQueryGrid,
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Trouvez les liens de vos Films et Series préférés en streaming.",
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}
