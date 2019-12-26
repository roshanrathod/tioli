import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class Inventory {
  String img;
  String title;
  String id;
  String description;
  var users;

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
}
