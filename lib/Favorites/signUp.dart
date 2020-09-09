import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  final ValueChanged<int> _setWhatToDisplay;
  final ValueChanged<Map> _setUser;
  final ValueChanged<bool> switchIsConnected;

  SignUp(this._setWhatToDisplay, this._setUser, this.switchIsConnected);

  @override
  _SignUpState createState() =>
      _SignUpState(_setWhatToDisplay, _setUser, switchIsConnected);
}

class _SignUpState extends State<SignUp> {
  final Map<String, String> _authentificationData = new Map<String, String>();
  final ValueChanged<int> _setWhatToDisplay;
  final ValueChanged<Map> _setUser;
  final ValueChanged<bool> switchIsConnected;

  _SignUpState(this._setWhatToDisplay, this._setUser, this.switchIsConnected);

  void changeState(String newValue, String field) => setState(
        () {
          _authentificationData[field] = newValue;
        },
      );

  void _signUp() {
    try {
      Firestore.instance
          .collection("Users")
          .where(
            "username",
            isEqualTo: _authentificationData["username"],
          )
          .getDocuments()
          .then((snaphshot) async {
        if (snaphshot.documents.length == 0) {
          FirebaseUser user =
              (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _authentificationData["email"],
            password: _authentificationData["password"],
          ))
                  .user;
          _setUser(
            {
              'fromAuth': user,
              'fromUsers':
                  Firestore.instance.collection('Users').document(user.uid)
            },
          );
          switchIsConnected(true);
          Firestore.instance.collection("Users").document(user.uid).setData(
            {
              'username': _authentificationData["username"],
            },
          );
          Firestore.instance
              .collection("Users")
              .document(user.uid)
              .collection('favorites')
              .document('Series')
              .setData({});
          Firestore.instance
              .collection("Users")
              .document(user.uid)
              .collection('favorites')
              .document('Films')
              .setData({});
          Firestore.instance
              .collection("Users")
              .document(user.uid)
              .collection('favorites')
              .document('Animes')
              .setData({});
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Ce nom d'utilisateur est déjà utilisé."),
              action: SnackBarAction(
                label: 'FERMER',
                onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
              ),
            ),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<FirebaseUser> createUser() async {
    return (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _authentificationData["email"],
      password: _authentificationData["password"],
    ))
        .user;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 70.0, 0, 0),
              child: Text(
                "Créez votre compte",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: .8,
                    letterSpacing: 2.0,
                    color: Colors.white,
                    fontFamily: 'Monserrat',
                    fontSize: 65.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            // Divider(
            //   color: Colors.grey[700],
            //   height: 110.0,
            //   thickness: 2.0,
            //   indent: 50.0,
            //   endIndent: 50.0,
            // ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  child: TextField(
                    onChanged: (text) => changeState(text, "email"),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent[700],
                        ),
                      ),
                      labelText: " EMAIL",
                      labelStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    child: TextField(
                      onChanged: (text) => changeState(text, "username"),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent[700],
                          ),
                        ),
                        labelText: " USERNAME",
                        labelStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 50.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    child: TextField(
                      onChanged: (text) => changeState(text, "password"),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent[700],
                          ),
                        ),
                        labelText: " PASSWORD",
                        labelStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Monserrat',
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 20.0),
                  child: Container(
                    height: 40.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[100],
                      shadowColor: Colors.grey[100],
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: _signUp,
                        child: Center(
                          child: Text(
                            "VALIDER",
                            style: TextStyle(
                                color: Colors.redAccent[700],
                                fontSize: 18.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 20.0),
                //   child: Container(
                //     height: 40.0,
                //     child: Material(
                //       borderRadius: BorderRadius.circular(20.0),
                //       color: Colors.grey[100],
                //       shadowColor: Colors.grey[100],
                //       elevation: 2.0,
                //       child: GestureDetector(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.only(right: 10.0),
                //               child: Image.asset(
                //                   "assets/images/f_logo_RGB-Blue_58.png",
                //                   height: 30.0),
                //             ),
                //             Center(
                //               child: Text(
                //                 "via Facebook",
                //                 style: TextStyle(
                //                     color: Color(0xFF1877F2),
                //                     fontSize: 18.0,
                //                     fontFamily: 'Montserrat',
                //                     fontWeight: FontWeight.bold),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                  child: Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous avez déjà un compte ?   ",
                          style: TextStyle(color: Colors.white),
                        ),
                        InkWell(
                          onTap: () {
                            _setWhatToDisplay(1);
                          },
                          child: Text(
                            "CONNECTEZ-VOUS",
                            style: TextStyle(
                              color: Colors.redAccent[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
