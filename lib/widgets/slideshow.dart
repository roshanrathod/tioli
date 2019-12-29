import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tioli/services/firebase_auth.dart';
import '../services/firebase_products.dart';

class SlideShowWidget extends StatefulWidget {
  final String currenUserDisplayName;
  SlideShowWidget({Key key, this.currenUserDisplayName}) : super(key: key);
  createState() => SlideShowWidgetState();
}

class SlideShowWidgetState extends State<SlideShowWidget> {
  PageController ctrl;
  bool _userWantsItem = false;
  List<Inventory> slides;
  int totalItems;
  String activeTag = 'favorites';

  //tracking current page
  int currentPage = 0;
  final firebaseAuth = new FirebaseAuthService();
  @override
  Future<void> initState() {
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
                return _buildStoryPage(slides[currentIdx - 1], active);
              }
            }));
  }

  void _queryDb({String tag = 'favorites'}) async {
    Inventory inv = new Inventory();
    slides = await inv.getAllItems();
    totalItems = slides.length + 1;
  }

// Builder Functions

  _buildStoryPage(Inventory data, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 35 : 0;
    final double top = active ? 10 : 15;
    var _alignment = Alignment.center;
    var _id = data.id;
    List<dynamic> usersOfCurrentItem = data.users;
    if (usersOfCurrentItem != null &&
        usersOfCurrentItem.contains(widget.currenUserDisplayName)) {
      _userWantsItem = true;
    } else {
      _userWantsItem = false;
    }

    _addUserForItem(_id) async {
      await data.updateUserForItem(_id, widget.currenUserDisplayName, true);
      await _queryDb();
      //}
      setState(() {
        _userWantsItem = true;
      });
    }

    _removeUserForItem(_id) async {
      await data.updateUserForItem(_id, widget.currenUserDisplayName, false);
      await _queryDb();
      setState(() {
        _userWantsItem = false;
      });
    }

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          flex: 1,
          child: Text(
            'Welcome ' + widget.currenUserDisplayName,
            style: TextStyle(fontSize: 20, fontFamily: 'comic sans ms'),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
            flex: 8,
            child: Container(
              //duration: Duration(milliseconds: 500),
              //curve: Curves.easeOutQuint,
              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  data.img,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
              //     // image: DecorationImage(
              //     //   fit: BoxFit.cover,
              //     //   image: NetworkImage(data.img),
              //     // ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.8),
              //         // spreadRadius: 10,
              //         // blurRadius: 5,
              //         offset: Offset(3, 5), // changes position of shadow
              //       ),
              //     ]),
              // child: Center(
              //   child: Text(data.title,
              //       style: TextStyle(fontSize: 40, color: Colors.white)),
              // )
            )),
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
                if (!_userWantsItem)
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, right: 10),
                        child: FloatingActionButton.extended(
                            backgroundColor: Colors.green[400],
                            foregroundColor: Colors.white,
                            onPressed: () {
                              _addUserForItem(_id);
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text("Take it!")),
                      )),
                if (_userWantsItem)
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, right: 10),
                        child: FloatingActionButton.extended(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                            onPressed: () {
                              _removeUserForItem(_id);
                            },
                            icon: Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
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
}
