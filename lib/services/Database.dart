import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData(String fullname, String phonenum, int age, String ville) async {
    return await userCollection.document(uid).setData({
      'fullname': fullname,
      'phonenum': phonenum,
      'age': age,
      'ville':ville,
    });
  }

  //get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}