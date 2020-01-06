import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:tioli/common/global.dart';
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
  bool _valid = true;

  void initState() {
    super.initState();
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
    validateForm();
    if (_valid) {
      try {
        if (_isRegisterFormVisible) {
          await firebaseAuth
              .createNewUser(nicknameController.text, emailController.text,
                  passwordController.text)
              .then((value) {
            setState(() {
              Navigator.pushReplacementNamed(this.context, router.PRODUCTS,
                  arguments: value.displayName);
            });
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
  }

  validateForm() {
    if (_isRegisterFormVisible) {
      if (nicknameController.text == null ||
          nicknameController.text == '' ||
          emailController.text == null ||
          emailController.text == '' ||
          passwordController.text == null ||
          passwordController.text == '') {
        setState(() {
          _valid = false;
        });
        showLoginValidationToast();
      } else {
        setState(() {
          _valid = true;
        });
      }
    } else {
      if (emailController.text == null ||
          emailController.text == '' ||
          passwordController.text == null ||
          passwordController.text == '') {
        setState(() {
          _valid = false;
        });
        showLoginValidationToast();
      } else {
        setState(() {
          _valid = true;
        });
      }
    }
  }

  showLoginValidationToast() {
    showToast(
      'One or more mandatory fields are left empty. ' +
          '\n' +
          'Please try again.',
      duration: Duration(seconds: 5),
      position: ToastPosition.bottom,
      backgroundColor: Colors.white,
      radius: 5.0,
      textStyle: TextStyle(
          fontSize: 16.0, color: Colors.red, fontFamily: 'comic sans ms'),
    );
  }

  void showRegisterForm() {
    setState(() {
      _isRegisterFormVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(child: TopNavigationBar()),
                if (_isRegisterFormVisible)
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nickname',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF999A9A),
                        ),
                      )),
                if (_isRegisterFormVisible)
                  Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        InputWidget(
                          0.0,
                          0.0,
                          false,
                          'Pick a cool nickname for yourself ...',
                          nicknameController,
                        ),
                      ],
                    ),
                    height: 60,
                  ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF999A9A),
                      ),
                    )),
                Container(
                  child: InputWidget(
                    0.0,
                    0.0,
                    false,
                    'Enter your email address to continue ...',
                    emailController,
                  ),
                  height: 60,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF999A9A),
                      ),
                    )),
                Container(
                  child: InputWidget(
                    0.0,
                    0.0,
                    true,
                    'Enter your password to continue ...',
                    passwordController,
                  ),
                  height: 60,
                ),
                FloatingActionButton.extended(
                  onPressed: submitForm,
                  label: Text('Submit'),
                  backgroundColor: Colors.blue,
                ),
                Row(
                  children: <Widget>[
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
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
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
}
