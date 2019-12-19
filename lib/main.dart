import 'package:flutter/material.dart';
import 'package:tioli/views/home_view.dart';
import 'package:firebase/firebase.dart' as firebase;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    firebase.initializeApp(
      apiKey: "AIzaSyDPrjwS1PyZ5RI-_36GH1WitD9ZENAJrDQ",
    authDomain: "tioli-c7b5e.firebaseapp.com",
    databaseURL: "https://tioli-c7b5e.firebaseio.com",
    projectId: "tioli-c7b5e",
    storageBucket: "tioli-c7b5e.appspot.com",
    messagingSenderId: "624629575687"
    );
    return MaterialApp(
      title: 'Take it or Leave it',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Open Sans'
        )
      ),
      home: HomeView(),
    ); 
  }
}
