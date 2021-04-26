import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/services/roomhandling.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //FirebaseFirestore db = FirebaseFirestore.instance;
  //collection reference
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('Profile');
  Rooms roomservice = new Rooms();

  Future addUserData(String name) async {
    return await profileCollection.doc(uid).set(
      {
        'name': name,
      },
    );
  }

  Future getusername(String uid) async {
    DocumentSnapshot dshot = await profileCollection.doc(uid).get();
    return dshot.data()['name'];
  }


  UserData _userDatafromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
    );
  }

  Stream<UserData> get customuserdata{
    return profileCollection.doc(uid).snapshots()
        .map(_userDatafromSnapshot);
  }

  Future addMyRoomData(String roomid,String roomname,String type) async {
    return await profileCollection.doc(uid)
        .collection('myrooms')
        .doc()
        .set({'roomname': roomname, 'roomid': roomid, 'roomtype': type});
  }

  Future addAttemptedRoomData(String roomid, String res) async {
    String temp = await roomservice.getroomname(roomid);
    return await profileCollection.doc(uid)
        .collection('attendedrooms')
        .doc()
        .set({'roomid': roomid, 'roomname': temp, 'score': res});
  }
}
