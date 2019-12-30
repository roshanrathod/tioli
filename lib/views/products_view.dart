import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tioli/widgets/centered_view/centered_view.dart';
import 'package:tioli/widgets/navigation/top_navigation_bar.dart';

import '../widgets/slideshow.dart';

class ProductsView extends StatelessWidget {
  final String username;

 ProductsView({Key key, this.username}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredView(
        child: Column(
          children: <Widget>[
            TopNavigationBar(),
            Expanded(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Expanded(
                    child: Center(
                      child: SlideShowWidget(currenUserDisplayName: username),

                    ), 
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
