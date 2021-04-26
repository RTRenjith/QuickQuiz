import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_quiz/models/FeedbackAttemptsModel.dart';
import 'package:quick_quiz/models/attended_rooms_model.dart';
import 'package:quick_quiz/models/myroom_model.dart';
import 'package:quick_quiz/models/ques_snap.dart';
import 'package:quick_quiz/models/attempts_model.dart';

class Rooms {
  String quizid = '';
  var res;

  final CollectionReference roomCollection = FirebaseFirestore.instance.collection('Rooms');


  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> updateQuestionData(quizData, String quizID) async {
    return await roomCollection.doc(quizID).collection('QnA').add(quizData);
  }

  Future<void> updateRoomnameData(String roomname, String quizID, String roomtype) async {
    return await roomCollection.doc(quizID).set({'roomname': roomname, 'roomtype': roomtype});
  }

  //add attemp data
  Future<void> addAttemptData(String username, String quizID, String score) async {
    return await roomCollection.doc(quizID).collection('Attempts').doc().set(
        {
          'username': username,
          'score': score,
        });
  }

  Future<void> addFeedbackAttemptData(String quizid,String feed,double rating) async {
    return await roomCollection.doc(quizid).collection('Attempts').doc().set({
      'rating' : rating,
      'feedback' : feed,
    });
  }

  Future<String> getRoomtype(String quizID) async {
    DocumentSnapshot roomtype = await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(quizID).get();
    return roomtype.get("roomtype");
  }

  Future<List<QuestionSnap>> getQuizData(String quizID) async {
    QuerySnapshot qshot = await FirebaseFirestore.instance
        .collection('Rooms')
       .doc(quizID)
           .collection('QnA')
           .get();

    return qshot.docs.map(
        (doc) => QuestionSnap(
          question: doc.data()["question"],
          option1: doc.data()["option1"],
          option2: doc.data()["option2"],
          option3: doc.data()["option3"],
          option4: doc.data()["option4"],
        )
    ).toList();
  }

  Future<List<MyRoomModel>> getMyRoomQuizData(String uid) async {
    print('inside room handling');
    QuerySnapshot qshot = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('myrooms').where('roomtype', isEqualTo: "Quiz").get();
    print(qshot);

    return qshot.docs.map(
            (doc) => MyRoomModel(
          roomName: doc.data()["roomname"],
          roomID: doc.data()["roomid"],
          roomType: doc.data()["roomtype"],
        )
    ).toList();
  }
  Future<List<MyRoomModel>> getMyRoomFeedbackData(String uid) async {
    print('inside room handling');
    QuerySnapshot qshot = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('myrooms').where('roomtype', isEqualTo: "Feedback").get();
    print(qshot);

    return qshot.docs.map(
            (doc) => MyRoomModel(
          roomName: doc.data()["roomname"],
          roomID: doc.data()["roomid"],
          roomType: doc.data()["roomtype"],
        )
    ).toList();
  }
  // Future<List<MyRoomModel>> getMyRoomData(String uid) async {
  //   print('inside room handling');
  //   QuerySnapshot qshot = await FirebaseFirestore.instance
  //       .collection('Profile')
  //       .doc(uid)
  //       .collection('myrooms').get();
  //   print(qshot);
  //
  //   return qshot.docs.map(
  //           (doc) => MyRoomModel(
  //         roomName: doc.data()["roomname"],
  //         roomID: doc.data()["roomid"],
  //         roomType: doc.data()["roomtype"],
  //       )
  //   ).toList();
  // }

  //for feedback
  Future<List<FeedbackAttemptsModel>> getFeedbackAttemptsData(String roomid) async {
    print('inside room handling');
    QuerySnapshot qshot = await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomid)
        .collection('Attempts')
        .get();
    print(qshot);

    return qshot.docs.map(
            (doc) => FeedbackAttemptsModel(
          feedback: doc.data()['feedback'],
          rating: doc.data()['rating'],
        )
    ).toList();
  }
  //for quiz
  Future<List<AttemptsModel>> getAttemptsData(String roomid) async {
    print('inside room handling');
    QuerySnapshot qshot = await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomid)
        .collection('Attempts')
        .get();
    print(qshot);

    return qshot.docs.map(
            (doc) => AttemptsModel(
              username: doc.data()['username'],
              score: doc.data()['score'],
        )
    ).toList();
  }

  Future<List<AttemptedRoomsModel>> getAttempedRoomData(String uid) async {
    print('inside room handling');
    QuerySnapshot qshot = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(uid)
        .collection('attendedrooms')
        .get();
    print(qshot);

    return qshot.docs.map(
            (doc) => AttemptedRoomsModel(
          roomid: doc.data()['roomid'],
              roomname: doc.data()['roomname'],
              score: doc.data()['score'],

              //.toString()
        )
    ).toList();
  }

  Future getroomname(String roomid) async {
    DocumentSnapshot dshot = await roomCollection.doc(roomid).get();
    return dshot.data()['roomname'];
  }

}

