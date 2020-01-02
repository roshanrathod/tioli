import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:oktoast/oktoast.dart';
import 'router.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    if (firebase.apps.length == 0) {
      firebase.initializeApp(
          apiKey: "AIzaSyDPrjwS1PyZ5RI-_36GH1WitD9ZENAJrDQ",
          authDomain: "tioli-c7b5e.firebaseapp.com",
          databaseURL: "https://tioli-c7b5e.firebaseio.com",
          projectId: "tioli-c7b5e",
          storageBucket: "tioli-c7b5e.appspot.com",
          messagingSenderId: "624629575687");
    }

    return OKToast (
      child:MaterialApp(
      title: 'Take it or Leave it',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'Open Sans')),
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
    )
    );
  }
}
