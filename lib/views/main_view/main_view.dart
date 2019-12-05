import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Welcome to TIOLI\n', 
            style: TextStyle(fontWeight: FontWeight.w800, height: 0.9, fontSize: 50)
            ),
            SizedBox(height: 30,),
            Text('TAKE IT OR LEAVE IT',
            style: TextStyle(fontSize: 21, height:1.7)
            )
        ],
      ),
    );
  }
}