import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tioli/widgets/centered_view/centered_view.dart';
import 'package:tioli/widgets/navigation/navigation_bar.dart';

class ProductsView extends StatelessWidget {

ProductsView({username : String});
final username = null;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredView(
        child: Column(
          children: <Widget>[
            NavigationBar(),
        ],),)

    );
  }
}