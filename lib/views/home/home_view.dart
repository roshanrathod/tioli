import 'package:flutter/material.dart';
import 'package:tioli/views/action_view/action_view.dart';
import 'package:tioli/views/main_view/main_view.dart';
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
                  MainView(),
                  Expanded(child: Center(child: ActionView('Show me what you got!'),),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}