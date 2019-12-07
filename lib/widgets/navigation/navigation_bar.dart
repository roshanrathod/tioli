import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 80, width: 150, child: Image.asset('assets/logo.png')),
          Text(
            'Welcome to TIOLI\n', 
            style: TextStyle(fontWeight: FontWeight.w600, height: 0.9, fontSize: 30)
            ),
            Text(
            '\nTake It Or Leave It\n', 
            style: TextStyle(fontWeight: FontWeight.w300, height: 0.9, fontSize: 30)
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _NavBarItem('Home'),
              SizedBox(width: 60,),
              _NavBarItem('About')
            ],
          )

        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  const _NavBarItem(this.title);


  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize:18),);
  }
}