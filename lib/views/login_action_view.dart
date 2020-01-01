import 'dart:html';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:tioli/common/global.dart';
import 'package:tioli/widgets/centered_view/centered_view.dart';
import 'package:tioli/widgets/inputWidget.dart';
import 'package:tioli/services/firebase_auth.dart';
import 'package:tioli/router.dart' as router;
import 'package:tioli/widgets/navigation/top_navigation_bar.dart';

class LoginActionView extends StatefulWidget {
  final String title;

  LoginActionView({Key key, this.title}) : super(key: key);
  @override
  _LoginActionViewState createState() => new _LoginActionViewState();
}

class _LoginActionViewState extends State<LoginActionView>
    with SingleTickerProviderStateMixin {
  final firebaseAuth = new FirebaseAuthService();
  final _global = new Global();
  bool _isRegisterFormVisible = false;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nicknameController = new TextEditingController();
  TabController _tabController;

  void initState() {
    super.initState();
    //_global.isLoggedIn = false;
    _global.currentUserName.then((val) {
      setState(() {
        if (val != null) {
          Navigator.pushReplacementNamed(this.context, router.PRODUCTS,
              arguments: val);
        }
      });
    });

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    var index = _tabController.index;
    print("Tab changed to index : $index");
    if (index == 0) {
      setState(() {
        _isRegisterFormVisible = false;
      });
    } else {
      setState(() {
        _isRegisterFormVisible = true;
      });
    }
  }

  submitForm() async {
    try {
      if (_isRegisterFormVisible) {
        await firebaseAuth
            .createNewUser(nicknameController.text, emailController.text,
                passwordController.text)
            .then((value) {
          setState(() {
            Navigator.pushReplacementNamed(this.context, router.PRODUCTS,
                arguments: value);
          });
          print("value returned after login : $value");
        });
      } else {
        await firebaseAuth
            .signIn(emailController.text, passwordController.text)
            .then((value) {
          setState(() {
            //window.console.dir(value);
            if (value != null) {
              Navigator.pushReplacementNamed(this.context, router.PRODUCTS,
                  arguments: value.displayName);
            }
          });
        });
      }
    } catch (e) {
      print("Unable to login user due to enter $e");
    }
  }

  void showRegisterForm() {
    setState(() {
      _isRegisterFormVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CenteredView(
            child: Column(children: <Widget>[
      TopNavigationBar(),
      Expanded(
          child: Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        Expanded(
            child: Center(
                child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            if (_isRegisterFormVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 0),
                    child: Text(
                      'Nickname',
                      style: TextStyle(fontSize: 16, color: Color(0xFF999A9A)),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      InputWidget(
                          10.0,
                          0.0,
                          false,
                          'Pick a cool nickname for yourself ...',
                          nicknameController),
                    ],
                  )
                ],
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
                    InputWidget(
                        10.0,
                        0.0,
                        false,
                        'Enter your email address to continue ...',
                        emailController),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 0),
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF999A9A),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    InputWidget(
                        1.0,
                        0.0,
                        true,
                        'Enter your password to continue ...',
                        passwordController),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            FloatingActionButton.extended(
              onPressed: submitForm,
              label: Text('Submit'),
              backgroundColor: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Expanded(
              child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: TabBar(
                    indicatorColor: Colors.blue[300],
                    labelColor: const Color(0xFF3baee7),
                    unselectedLabelColor: Colors.lightBlue[100],
                    labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                        text: "LOGIN",
                      ),
                      Tab(
                        text: "REGISTER",
                      )
                    ],
                    controller: _tabController,
                  )),
            )
          ],
        )))
      ]))
    ])));
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
