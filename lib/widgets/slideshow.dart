import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tioli/services/firebase_auth.dart';
import '../services/firebase_products.dart';
import 'package:tioli/common/constants.dart' as constants;

class SlideShowWidget extends StatefulWidget {
  final String currenUserDisplayName;
  SlideShowWidget({Key key, this.currenUserDisplayName}) : super(key: key);
  createState() => SlideShowWidgetState();
}

class SlideShowWidgetState extends State<SlideShowWidget>
    with SingleTickerProviderStateMixin {
  PageController ctrl;
  bool _userWantsItem = false;
  List<Inventory> slides;
  List<Inventory> availableItems;
  List<Inventory> takenItems;
  List<Inventory> myItems;
  int totalItems;
  String activeTag = 'favorites';
  TabController _tabController;
  int _showingTabIndex = 0;
  String _positiveButtonText;
  String _negativeButtonText;
  String textToDisplay = constants.showingAvailableItems;

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
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    var index = _tabController.index;
    print("Tab changed to index : $index");
    setState(() {
      _showingTabIndex = index;
      switch (_showingTabIndex) {
        case 0: // available items
          _positiveButtonText = constants.takeIt;
          _negativeButtonText = constants.leaveIt;
          slides = availableItems;
          textToDisplay = constants.showingAvailableItems;
          totalItems = availableItems.length + 1;
          break;
        case 1: // taken by someone else items
          _positiveButtonText = constants.interestedInItem;
          _negativeButtonText = constants.noLongerInterested;
          slides = takenItems;
          textToDisplay = constants.showingTakenItems;
          totalItems = takenItems.length + 1;
          break;
        case 2: // items booked by current user
          _positiveButtonText = constants.takeIt;
          _negativeButtonText = constants.leaveIt;
          slides = myItems;
          textToDisplay = constants.showingMineItems;
          totalItems = myItems.length + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Text(
          'Welcome ' + widget.currenUserDisplayName,
          style: TextStyle(fontSize: 15, fontFamily: 'comic sans ms'),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
          flex: 9,
          child: PageView.builder(
              controller: ctrl,
              itemCount: totalItems,
              itemBuilder: (context, int currentIdx) {
                if (currentIdx == 0) {
                  return _buildTagPage(_showingTabIndex);
                } else if (slides.length >= currentIdx) {
                  // Active page
                  bool active = currentIdx == currentPage;
                  return _buildStoryPage(slides[currentIdx - 1], active);
                }
              })),
      Expanded(
        child: new Align(
            alignment: Alignment.bottomCenter,
            child: TabBar(
              indicatorColor: Colors.blue[300],
              labelColor: const Color(0xFF3baee7),
              unselectedLabelColor: Colors.lightBlue[100],
              labelStyle: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: "AVAILABLE",
                ),
                Tab(
                  text: "TAKEN",
                ),
                Tab(
                  text: "MINE",
                )
              ],
              controller: _tabController,
            )),
      )
    ]));
  }

  void _queryDb({String tag = 'favorites'}) async {
    Inventory inv = new Inventory();
    availableItems = await inv.getAllAvailable();
    takenItems = await inv.getAllTakenItems(widget.currenUserDisplayName);
    myItems = await inv.getMyItems(widget.currenUserDisplayName);
    if (_showingTabIndex == 0) {
      slides = availableItems;
      _positiveButtonText = constants.takeIt;
      _negativeButtonText = constants.leaveIt;
    } else if (_showingTabIndex == 2) {
      slides = myItems;
    } else
      slides = takenItems;
    totalItems = slides.length + 1;
  }

// Builder Functions

  _buildStoryPage(Inventory data, bool active) {
    var _id = data.id;
    List<dynamic> interestedUsers = data.interestedUsers;
    String firstUser = data.firstUser;
    if (interestedUsers != null &&
            interestedUsers.contains(widget.currenUserDisplayName) ||
        (firstUser == widget.currenUserDisplayName)) {
      _userWantsItem = true;
    } else {
      _userWantsItem = false;
    }

    _addUserForItem(_id) async {
      await data.updateUserForItem(
          _id, widget.currenUserDisplayName, true, _showingTabIndex);
      await _queryDb();
      //}
      setState(() {
        _userWantsItem = true;
      });
    }

    _removeUserForItem(_id) async {
      await data.updateUserForItem(
          _id, widget.currenUserDisplayName, false, _showingTabIndex);
      await _queryDb();
      setState(() {
        _userWantsItem = false;
        print("_userWantsItem : $_userWantsItem ");
      });
    }

    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (_showingTabIndex == 1)
          Expanded(
            flex: 1,
            child: Text(
                "Item booked by : " +
                    data.firstUser +
                    "\n" +
                    "Users interested in this product : " +
                    data.interestedUsers
                        .reduce((value, element) => value + ',' + element),
                maxLines: 5,
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontFamily: 'comic sans ms')),
          ),
        Expanded(
            flex: 8,
            child: Container(
             margin: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  data.img,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
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
                /* Show 'take it' button if user is on Available tab
                   Show 'interested' button if user is on Taken tab and not amongst interested users. 
                */
                if (!_userWantsItem && !(_showingTabIndex == 2) ||
                    _showingTabIndex == 0)
                  Expanded(
                      flex: 6,
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
                            label: Text(_positiveButtonText)),
                      )),
                /* show 'leave it' button if user is first user and on Mine tab
                   show 'Not interested' button if user is not first user and on Taken tab.
                */
                if (_userWantsItem &&
                    (_showingTabIndex == 2 || _showingTabIndex == 1))
                  Expanded(
                      flex: 6,
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
                            label: Text(_negativeButtonText)),
                      )),
              ],
            ))
      ]),
    );
  }

  _buildTagPage(int tabIndex) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textToDisplay,
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
