import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:StreamLink/Favorites/connectedBody.dart';
import '../Util/navBar.dart';
import 'homeBody.dart';
import '../Discovery/discoveryBody.dart';
import '../Favorites/favoritesBody.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseUser _user;
  DocumentReference _userfromUsers;
  int _currentIndex = 1;
  List _tabs = [
    [true, DiscoveryBody(), "Accueil"],
    [true, HomeBody(), "Rechercher"],
    [false, FavoritesBody(), "Vos Favoris"]
  ];
  bool isConnected = false;

  void setUser(Map map) {
    setState(() {
      _user = map['fromAuth'];
      _userfromUsers = map['fromUsers'];
    });
  }

  void switchIsConnected(bool connection) {
    setState(() {
      isConnected = connection;
      if (isConnected) {
        _tabs[2][1] = ConnectedBody(_user, _userfromUsers, switchIsConnected);
      } else {
        _tabs[2][1] = FavoritesBody(
          setUser: setUser,
          switchIsConnected: switchIsConnected,
        );
        _tabs[0][1] = DiscoveryBody();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (isConnected) {
        _tabs[2][1] = ConnectedBody(_user, _userfromUsers, switchIsConnected);
        _tabs[0][1] = DiscoveryBody(
          user: _user,
        );
      } else {
        _tabs[1][1] = HomeBody(user: _user);
        _tabs[0][1] = DiscoveryBody(user: _user);
        _tabs[2][1] = FavoritesBody(
          setUser: setUser,
          switchIsConnected: switchIsConnected,
        );
      }
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _tabs[_currentIndex][0] ? NavBar(context) : null,
      body: _tabs[_currentIndex][1],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.black,
        selectedIconTheme:
            IconThemeData(color: Colors.redAccent[700], size: 35.0),
        unselectedItemColor: Colors.grey[400],
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Accueil"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            title: Text("Rechercher"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text("Vos Favoris"),
          ),
        ],
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
    );
  }
}
