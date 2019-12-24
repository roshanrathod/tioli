import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:tioli/widgets/inputWidget.dart';
import 'package:tioli/services/firebase_auth.dart';
import 'package:tioli/router.dart' as router;

class LoginActionView extends StatefulWidget {
  final String title;

  LoginActionView({Key key, this.title}) : super(key: key);
  @override
  _LoginActionViewState createState() => new _LoginActionViewState();
}

class _LoginActionViewState extends State<LoginActionView> {
  final firebaseAuth = new FirebaseAuthService();
  void tryToLogin() async {
   try {
      Future<User> firebaseUser = firebaseAuth.createNewUser("firstname", "lastname","anjanapai2508@gmail.com", "password123");
      setState(() {
       Navigator.pushReplacementNamed(this.context, router.PRODUCTS,
            arguments: firebaseUser);
      });
    } catch (e) {
      print('Unable to login for error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, bottom: 0),
              child: Text(
                'Email',
                style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                InputWidget(20.0, 0.0),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Enter your email id to continue ...',
                          textAlign: TextAlign.end,
                          style:
                              TextStyle(color: Color(0xFFA0A0A0), fontSize: 12),
                        ),
                      )),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            gradient: LinearGradient(
                                colors: signInGradients,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: ImageIcon(
                          AssetImage("assets/logo.png"),
                          size: 40,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 0),
        ),
        RaisedButton(
            onPressed: tryToLogin,
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child:
                    const Text('Login Button', style: TextStyle(fontSize: 20))))
      ],
    );
  }
}

Widget customRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(
    builder: (BuildContext mContext) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Stack(
          alignment: Alignment(1.0, 0.0),
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(mContext).size.width / 0.5,
              height: 50,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            Visibility(
                visible: isEndIconVisible,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: ImageIcon(
                    AssetImage("assets/logo.png"),
                    size: 30,
                    color: Colors.amber,
                  ),
                ))
          ],
        ),
      );
    },
  );
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
