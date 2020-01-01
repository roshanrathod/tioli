import 'dart:html';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class Inventory {
  String img;
  String title;
  String id;
  String description;
  String firstUser;
  List<dynamic> interestedUsers;
  Map<String, dynamic> data;
  String modifiedFirstUser;

  final CollectionReference ref;

  Inventory() : ref = fb.firestore().collection('inventory');

  Future<List<Inventory>> getItems() async {
    List<Inventory> allItems = new List<Inventory>();
    var snapshot = await ref.get();

    for (var item in snapshot.docs) {
      Inventory inv = new Inventory();
      inv.id = item.id;
      inv.firstUser = item.get("first_user");
      inv.interestedUsers = item.get("interested_users");
      inv.title = item.get("title");
      inv.description = item.get("description");
      inv.img = item.get("img");
      allItems.add(inv);
    }
    return allItems;
  }

  Future<List<Inventory>> getAllAvailable() async {
    //get all items
    List<Inventory> allAvailableItems = new List<Inventory>();
    await this.getItems().then((allItems) {
      //filter for this condition
      for (var eachItem in allItems) {
        if (eachItem.firstUser == null || eachItem.firstUser == '') {
          allAvailableItems.add(eachItem);
        }
      }
    });
    return allAvailableItems;
  }

  Future<List<Inventory>> getAllTakenItems(String currentUser) async {
    //get all items
    List<Inventory> allTakenItems = new List<Inventory>();
    await this.getItems().then((allItems) {
      //filter for this condition
      for (var eachItem in allItems) {
        if (eachItem.firstUser != null &&
            eachItem.firstUser != '' &&
            eachItem.firstUser != currentUser) {
          allTakenItems.add(eachItem);
        }
      }
    });
    return allTakenItems;
  }

  Future<List<Inventory>> getMyItems(String currentUser) async {
//get all items
    List<Inventory> myItems = new List<Inventory>();
    await this.getItems().then((allItems) {
      //filter for this condition
      for (var eachItem in allItems) {
        if (eachItem.firstUser != null && eachItem.firstUser == currentUser) {
          myItems.add(eachItem);
        }
      }
    });
    return myItems;
  }

  updateUserForItem(_id, _currentUser, addUser, tabIndex) async {
    await ref.doc(_id).get().then((dataQueried) {
      data = dataQueried.data();
      switch (tabIndex) {
        // User is on Available tab
        case 0:
          interestedUsers = data['interested_users'];
          //User has tapped 'Take it' button so add user as first user.
          if (addUser)
            modifiedFirstUser = _currentUser;
          else
            //User has tapped 'Leave it' button remove user from first user.
            modifiedFirstUser = '';
          break;
        //User is on Taken tab
        case 1:
          modifiedFirstUser = data['first_user'];
          interestedUsers =
              data['interested_users'] != null ? data['interested_users'] : [];
          // Add user to list of interested users.
          if (addUser)
            interestedUsers.add(_currentUser);
          else
            // Remove user from list of interested users.
            interestedUsers.remove(_currentUser);
          break;
        //User is on Mine tab
        case 2:
          // Items on Mine tab have current user as the first user so tapping on
          // 'Leave it' button will result in removing user as the first user.
          modifiedFirstUser = '';
          interestedUsers = data['interested_users'];
          break;
        default:
          print('Unable to get tab index');
      }

      var newData = {
        'id': data['id'],
        'first_user': modifiedFirstUser,
        'interested_users': interestedUsers,
        'title': data['title'],
        'description': data['description'],
        'img': data['img']
      };
      print('item goes to : $modifiedFirstUser');
      print('also interested : $interestedUsers');
      ref.doc(_id).set(newData, SetOptions(merge: true));
    });
  }
}
