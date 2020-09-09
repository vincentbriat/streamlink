import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgottenPassword.dart';

class LogIn extends StatefulWidget {
  final ValueChanged<int> _setWhatToDisplay;
  final ValueChanged<Map<FirebaseUser, DocumentReference>> _setUser;
  final ValueChanged<bool> switchIsConnected;

  LogIn(this._setWhatToDisplay, this._setUser, this.switchIsConnected);
  @override
  _LogInState createState() =>
      _LogInState(_setWhatToDisplay, _setUser, switchIsConnected);
}

class _LogInState extends State<LogIn> {
  Map<String, String> _authentificationData = new Map<String, String>();
  final ValueChanged<int> _setWhatToDisplay;
  final ValueChanged<Map> _setUser;
  final ValueChanged<bool> switchIsConnected;

  _LogInState(this._setWhatToDisplay, this._setUser, this.switchIsConnected);

  void changeState(String newValue, String field) => setState(
        () {
          _authentificationData[field] = newValue;
        },
      );

  Future<void> _logIn() async {
    if (_authentificationData["emailOrUsername"].contains("@")) {
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _authentificationData["emailOrUsername"],
                    password: _authentificationData["password"]))
            .user;
        _setUser({
          'fromAuth': user,
          'fromUsers': Firestore.instance.collection('Users').document(user.uid)
        });
        switchIsConnected(true);
      } catch (e) {
        print(e);
      }
    } else {
      Firestore.instance
          .collection("Users")
          .where('username',
              isEqualTo: _authentificationData['emailOrUsername'])
          .getDocuments()
          .then(
            (snap) => snap.documents.forEach(
              (document) async {
                try {
                  FirebaseUser user = (await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: document.documentID,
                              password: _authentificationData["password"]))
                      .user;
                  _setUser({
                    'fromAuth': user,
                    'fromUsers': Firestore.instance
                        .collection('Users')
                        .document(user.uid)
                  });
                  switchIsConnected(true);
                } catch (e) {
                  print(e);
                }
              },
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 80.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 70.0, 0, 0),
              child: Text(
                "Connectez-vous",
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
                    onChanged: (text) => changeState(text, "emailOrUsername"),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent[700],
                        ),
                      ),
                      labelText: " USERNAME OR EMAIL",
                      labelStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: 'Monserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
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
                        onTap: _logIn,
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
                //       ),i
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgottenPassword())),
                    child: Text(
                      'Mot de Passe oublié ?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
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
                            _setWhatToDisplay(0);
                          },
                          child: Text(
                            "S'ENREGISTRER",
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
            ),
          ],
        ),
      ),
    );
  }
}
