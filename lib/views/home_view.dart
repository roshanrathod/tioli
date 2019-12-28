import 'package:flutter/material.dart';
import 'package:tioli/views/login_action_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginActionView(
      title: 'LOGIN PAGE',
    );
  }
}
