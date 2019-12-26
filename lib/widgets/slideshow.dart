import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase/firestore.dart';

import '../services/firebase_products.dart';

class SlideShowWidget extends StatefulWidget {
  createState() => SlideShowWidgetState();
}

class SlideShowWidgetState extends State<SlideShowWidget> {
  PageController ctrl;

  List<Inventory> slides;
  int totalItems;

  String activeTag = 'favorites';

  //tracking current page
  int currentPage = 0;

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
    // // Update the active tag
    // setState(() {
    //   activeTag = tag;
    // });
  }

// Builder Functions

  _buildStoryPage(Inventory data, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    var _alignment = Alignment.bottomCenter;
    var _id = data.id;
    bool _visible = true;

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
                            style:
                                TextStyle(fontSize: 15, color: Colors.black)))),
                if(_visible)
                  Expanded(
                    flex: 2,                    
                    child: Padding(
                      padding:  EdgeInsets.only(right: 10),                   
                      child:                       
                        FloatingActionButton.extended(
                          backgroundColor: Colors.green,
                          onPressed: () {
                            _addUserForItem(_id);

                            setState(() {
                              _visible = false;                              
                            });
                          },
                          icon: Icon(Icons.check_circle),
                          label: Text("I want it!")),
                    )),
              ],
            ))
      ]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //     backgroundColor: Colors.green,
      //     onPressed: () {
      //       _addUserForItem(_id);

      //       setState(() {
      //         _visible = !_visible;
      //         _alignment = Alignment.center;
      //       });
      //     },
      //     icon: Icon(Icons.check_circle),
      //     label: Text("I want it!")),
    );
  }

  _addUserForItem(_id) {
    print(_id + "user wants it!");
  }

  _buildTagPage() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stories',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text('FILTER', style: TextStyle(color: Colors.black26)),
        _buildButton('favorites')
      ],
    ));
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple : Colors.white;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () => _queryDb(tag: tag));
  }
}
