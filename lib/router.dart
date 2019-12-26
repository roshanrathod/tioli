import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tioli/services/firebase_auth.dart';
import 'package:tioli/views/home_view.dart';
import 'package:tioli/views/login_action_view.dart';
import 'package:tioli/views/products_view.dart';

const String HOME = '/';
const String LOGIN = 'LOGIN';
const String PRODUCTS = 'PRODUCTS';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  print("route settings name : $routeSettings.name");
  switch (routeSettings.name) {
    case HOME:
      return MaterialPageRoute(builder: (context) => HomeView());
      break;
    case LOGIN:
      return MaterialPageRoute(builder: (context) {
        return ChangeNotifierProvider<FirebaseAuthService>(
          child: LoginActionView(),
          create: (BuildContext context) {
            return FirebaseAuthService();
          },
        );
      });
      break;
    case PRODUCTS:
    print("into products :routeSettings.arguments : $routeSettings.arguments");
      return MaterialPageRoute(builder: (context) {
        return ChangeNotifierProvider<FirebaseAuthService>(
          child: ProductsView(
              username: routeSettings.arguments,
          ),
          create: (BuildContext context) {
            return FirebaseAuthService();
          },
        );
      });
      break;
      default:
      return MaterialPageRoute(builder: (context) => HomeView());
  }
}
