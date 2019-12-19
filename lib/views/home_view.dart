import 'package:flutter/material.dart';
import 'package:tioli/views/login_action_view.dart';
// import 'package:tioli/views/login_action_view.dart';
import 'package:tioli/widgets/centered_view/centered_view.dart';
import 'package:tioli/widgets/navigation/navigation_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: CenteredView(
              child: Column(
          children: <Widget>[
            NavigationBar(),
            Expanded(
              child: Row(
                children: <Widget>[
                   Expanded(child: Center(child: LoginActionView(),),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}