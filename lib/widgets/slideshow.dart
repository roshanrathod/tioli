import 'dart:html';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase/firestore.dart';
import 'package:tioli/services/firebase_auth.dart';

import '../services/firebase_products.dart';

class SlideShowWidget extends StatefulWidget {
  createState() => SlideShowWidgetState();
}

class SlideShowWidgetState extends State<SlideShowWidget> {
  PageController ctrl;
 bool _userWantsItem = false;
  List<Inventory> slides;
  int totalItems;
  User currentUser;
  String activeTag = 'favorites';

  //tracking current page
  int currentPage = 0;
  final firebaseAuth = new FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    ctrl = PageController();
    _queryDb();

    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            controller: ctrl,
            itemCount: totalItems,
            itemBuilder: (context, int currentIdx) {
              if (currentIdx == 0) {
                return _buildTagPage();
              } else if (slides.length >= currentIdx) {
                // Active page
                bool active = currentIdx == currentPage;
                // print(active.toString() + " | " + currentIdx.toString());
                return _buildStoryPage(slides[currentIdx - 1], active);
              }
            }));
  }

  void _queryDb({String tag = 'favorites'}) async {
    // Make a Query
    // Query query = db.collection('stories').where('tags', arrayContains: tag);

    // Map the documents to the data payload
    Inventory inv = new Inventory();
    slides = await inv.getAllItems();
    totalItems = slides.length + 1;
    await firebaseAuth.currentUser().then((user){
      this.currentUser = user;
    });
    // // Update the active tag
    // setState(() {
    //   activeTag = tag;
    // });
  }

// Builder Functions

  _buildStoryPage(Inventory data, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 35 : 0;
    final double top = active ? 10 : 15;
    var _alignment = Alignment.center;
    var _id = data.id;
  
 _addUserForItem(_id) async{
    print(_id + "user wants it!");
    //Add user to inventory database
    await firebaseAuth.currentUser().then((user) {
      this.currentUser = user;
      if(this.currentUser != null)
      {
         Inventory inv = new Inventory();
         inv.updateUserForItem(_id, this.currentUser.displayName);
      }
    });
    setState(() {
      _userWantsItem = true;
    });
  }

  _removeUserForItem(_id) {
    print(_id + "User doesnot want it");
    setState(() {
      _userWantsItem = false;
    });
  }
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
            flex: 9,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutQuint,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(data.img),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: blur,
                          offset: Offset(offset, offset))
                    ]),
                child: Center(
                  child: Text(data.title,
                      style: TextStyle(fontSize: 40, color: Colors.white)),
                ))),
        Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 8,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(data.description,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'comic sans ms')))),
                                //checkifItemIsTaken(data.id),
                if (!_userWantsItem)
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: FloatingActionButton.extended(
                            backgroundColor: Colors.yellow[50],
                            foregroundColor: Colors.black,
                            onPressed: ()
                            {
                              _addUserForItem(_id);
                            },
                            icon: Icon(Icons.check_circle, color: Colors.green[300],),
                            label: Text("Take it!")),
                      )),
                      if (_userWantsItem)
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: FloatingActionButton.extended(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.black,
                            onPressed: () {
                              _removeUserForItem(_id);
                             },
                            icon: Icon(Icons.close, color: Colors.red,),
                            label: Text("Leave it")),
                      )),
              ],
            ))
      ]),
    );
  }

  _buildTagPage() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Swipe left to view and select items',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'comic sans ms'),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }

  // _buildButton(tag) {
  //   Color color = tag == activeTag ? Colors.purple : Colors.white;
  //   return FlatButton(
  //       color: color,
  //       child: Text('#$tag'),
  //       onPressed: () => _queryDb(tag: tag));
  // }
}
