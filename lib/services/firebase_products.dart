import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class Inventory {
  String img;
  String title;
  String id;
  String description;
  var users;
  Map<String, dynamic> data;
  List<dynamic> modifiedUsers = [];

  final CollectionReference ref;

  Inventory() : ref = fb.firestore().collection('inventory');

  Future<List<Inventory>> getAllItems() async {
    List<Inventory> allItems = new List<Inventory>();
    var snapshot = await ref.get();

    for (var item in snapshot.docs) {
      Inventory inv = new Inventory();
      inv.id = item.id;
      inv.users = item.get("users");
      inv.title = item.get("title");
      inv.description = item.get("description");
      // window.console.dir(item.id);
      inv.img = item.get("img");
      allItems.add(inv);
    }

    return allItems;
  }

  updateUserForItem(_id,_currentUser) async {
    await ref.doc(_id).get().then((dataQueried){
      data = dataQueried.data(); 
      if(data['users']!=null)
      modifiedUsers = data['users'] !=null? data['users'] : [];
      print("existing users : $modifiedUsers");
      modifiedUsers.add(_currentUser);
      var newData = {
      'id':data['id'],
      'users': modifiedUsers,
      'title': data['title'],
      'description': data['description'],
      'img':data['img']
    };
      print("new list of users to be added : $modifiedUsers");
      ref.doc(_id).set(newData, SetOptions(merge: true));
    });
  }
}
