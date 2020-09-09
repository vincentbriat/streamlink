import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:StreamLink/Discovery/title.dart';
import 'package:StreamLink/Util/categoryBuilderLimited.dart';

class DiscoveryBody extends StatefulWidget {
  final FirebaseUser user;

  DiscoveryBody({this.user});

  @override
  _DiscoveryBody createState() => _DiscoveryBody(user);
}

class _DiscoveryBody extends State<DiscoveryBody> {
  var list = [
    "Streamlink",
    "Series",
    "Shows",
    "Series",
    "Shows",
    "Series",
    "Shows"
  ];

  FirebaseUser _user;

  _DiscoveryBody(this._user);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        CategoryBuilderLimitedOrderByFavorites(
            'Titles', .55 * MediaQuery.of(context).size.height, _user),
        // Stack(children: <Widget>[
        //   Container(
        //     height: 300.0,
        //     color: Colors.grey[400],
        //   ),
        //   Text("Streamlink")
        // ]),
        TitleDiscoveryBody("Séries"),
        CategoryBuilderLimited("Series", 130.0, _user),
        TitleDiscoveryBody("Films"),
        CategoryBuilderLimited("Films", 130.0, _user),
        TitleDiscoveryBody("Animés"),
        CategoryBuilderLimited("Animes", 130.0, _user),
        /*SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return index % 2 != 0 || index == 0
              ? Text(list[index])
              : Flex(direction: Axis.horizontal, children: <Widget>[
                  CategoryBuilder(collection: list[index], numberOfColumns: 1)
                ]);
        }, childCount: list.length))*/
      ],
    );
  }
}
