import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_quiz/screens/home/create_quiz.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:random_string/random_string.dart';
import 'package:quick_quiz/screens/home/copy_room_code.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/services/database.dart';
import 'package:quick_quiz/models/user.dart';

class CreateRoomBottomSheet extends StatefulWidget {
  @override
  _CreateRoomBottomSheetState createState() => _CreateRoomBottomSheetState();
}

class _CreateRoomBottomSheetState extends State<CreateRoomBottomSheet> {
  final _formkey = GlobalKey<FormState>();

  String roomname = '';
  String roomtype = '';
  String quizID = '';
  int selectedRadio;
  String buttonText = '';
  String streamuserdata='';

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    if (val == 1) {
      setState(() {
        selectedRadio = 1;
        roomtype = "Quiz";
        buttonText = "Create Quiz";
      });
    } else if (val == 2) {
      setState(() {
        selectedRadio = 2;
        roomtype = "Feedback";
        buttonText = "Create Feedback";
      });
    }
  }

  addFeedbackRoomDetailsToMyRooms() async {
    await DatabaseService(uid: streamuserdata)
        .addMyRoomData(quizID, roomname, roomtype);
  }

  updateroomname() {
    if (_formkey.currentState.validate()) {
      setState(() {
        quizID = randomAlphaNumeric(5);
      });

      Rooms().updateRoomnameData(roomname, quizID, roomtype);
      if (selectedRadio == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    QuestionPage(roomname: roomname, quizid: quizID, roomtype: roomtype)));
      } else if (selectedRadio == 2) {
        //Navigator.pop(context);
        addFeedbackRoomDetailsToMyRooms();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CopyCode(roomname: roomname, quizid: quizID)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final streamDataabtUser = Provider.of<CustomUser>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: streamDataabtUser.uid).customuserdata,
        builder: (context, snapshot) {
          return Form(
            key: _formkey,
            child: Column(
              children: [
                Text(
                  'Enter Room Name',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Room name required' : null,
                  onChanged: (val) {
                    setState(() {
                      roomname = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Room name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue[900],
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 1,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        }),
                    Text(
                      'Quiz',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                        value: 2,
                        groupValue: selectedRadio,
                        activeColor: Colors.green,
                        onChanged: (val) {
                          print("Radio $val");
                          setSelectedRadio(val);
                        }),
                    Text(
                      'Feedback',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              if(buttonText != "")  RaisedButton(
                  color: Colors.blue[900],
                  child: Text(
                    '$buttonText',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      streamuserdata=streamDataabtUser.uid;
                    });
                    updateroomname();
                  },
                ),
              ],
            ),
          );
        });
  }
}
