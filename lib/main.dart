import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'router.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    if (firebase.apps.length == 0) {
      firebase.initializeApp(
          apiKey: "xxxx",
          authDomain: "xxxx",
          databaseURL: "xxxx",
          projectId: "xxxx",
          storageBucket: "xxxx",
          messagingSenderId: "xxxx");
    }

    return MaterialApp(
      title: 'Take it or Leave it',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'Open Sans')),
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    );
  }
}
