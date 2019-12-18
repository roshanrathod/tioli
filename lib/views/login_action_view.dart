import 'package:flutter/material.dart';
import 'package:tioli/widgets/inputWidget.dart';
import 'package:tioli/services/firebase_auth.dart';

class LoginActionView extends StatelessWidget {
  //final String title;
  LoginActionView({firebaseAuth:FirebaseAuthService});
  
  final firebaseAuth = new FirebaseAuthService();

  void tryToLogin() {
    try {
      firebaseAuth.createNewUser("anjanapai2508@gmail.com", "password123");
    } catch (e) {
      print("Error while trying to create user : $e");
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
        //customRectButton("Lets get Started", signInGradients, false),
        //customRectButton("Create an Account", signUpGradients, false),
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
              //padding: EdgeInsets.only(top: 16),
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
