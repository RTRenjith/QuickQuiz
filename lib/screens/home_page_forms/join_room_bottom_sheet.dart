import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quick_quiz/screens/home/attend_quiz.dart';
import 'package:quick_quiz/screens/home/feedback_page.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:quick_quiz/services/roomhandling.dart';
class JoinRoomSheet extends StatefulWidget {
  @override
  _JoinRoomSheetState createState() => _JoinRoomSheetState();
}

class _JoinRoomSheetState extends State<JoinRoomSheet> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  Rooms roominstance = new Rooms();
  final _formkey = GlobalKey<FormState>();
  String roomCode = '';
  String error = '';
  String roomtype='';

  setError(){
    setState(() {
      error = "room doesnot exists";
    });
  }

  goInsideFeedback(){
    setState(() {
      error = '';
    });
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => FeedbackForm(
          quizid: roomCode,
        )
    ));
  }

  goInsideQuiz(){
    setState(() {
      error = '';
    });
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => QuizPage(
        quizid: roomCode,
      )
    ));
  }

  joinRoom() async {
    if (_formkey.currentState.validate()) {

      db.collection('Rooms').doc(roomCode).get()
          .then((docSnapshot)  async {
      if(docSnapshot.exists){
          roomtype = await roominstance.getRoomtype(roomCode);
          print(roomtype);
        print(docSnapshot.id);
        if(roomtype == "Quiz") {
          goInsideQuiz();
        }else if(roomtype == "Feedback"){
          goInsideFeedback();
        }
    }else{
        setError();
    }
  });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            Text(
              'Enter Room Code',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              validator: (val) => val.isEmpty ? 'Invalid Room Code' : null,
              onChanged: (val) {
                setState(() {
                  roomCode = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Room code',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue[900],
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.blue[900],
              child: Text(
                'Join Room',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                joinRoom();

              },
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
  }
}
