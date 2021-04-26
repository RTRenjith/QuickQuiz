import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/services/database.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:quick_quiz/screens/home/copy_room_code.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class QuestionPage extends StatefulWidget {
  String roomname = '';
  String quizid = '';
  String roomtype='';
  QuestionPage({Key key, @required this.roomname, this.quizid,this.roomtype})
      : super(key: key);
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String quizID = '';

  Rooms roomhandling = new Rooms();
  final _formkey = GlobalKey<FormState>();

  final questionclr = TextEditingController();
  final op1clr = TextEditingController();
  final op2clr = TextEditingController();
  final op3clr = TextEditingController();
  final op4clr = TextEditingController();

  clearTxtInput() {
    questionclr.clear();
    op1clr.clear();
    op2clr.clear();
    op3clr.clear();
    op4clr.clear();
  }

  navToCopyScreen(){
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CopyCode(roomname: widget.roomname,quizid: widget.quizid)));
  }

  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";


  uploadQuizData() {
    if (_formkey.currentState.validate()) {
      // setState(() {
      //   isLoading = true;
      // });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      print(questionMap);


      roomhandling.updateQuestionData(questionMap, quizID).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        // setState(() {
        //   isLoading = false;
        // });
      }).catchError((e) {
        print(e);
        print('hi');
      });
    } else {
      print("error is happening ");
    }
  }

  @override
  Widget build(BuildContext context) {

    final streamDataabtUser = Provider.of<CustomUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: streamDataabtUser.uid).customuserdata,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.roomname),
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0 , 16.0, 0.0),
            child: SingleChildScrollView(
              child: Form(

                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    TextFormField(
                      maxLines: 5,
                      controller: questionclr,
                      validator: (val) => val.isEmpty ? 'Question required' : null,
                      onChanged: (val) {
                        setState(() {
                          question = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Question',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue[900],
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: op1clr,
                      validator: (val) => val.isEmpty ? 'Option 1 required' : null,
                      onChanged: (val) {
                        setState(() {
                          option1 = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Option1(Correct Answer)',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue[900],
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: op2clr,
                      validator: (val) => val.isEmpty ? 'Option 2 required' : null,
                      onChanged: (val) {
                        setState(() {
                          option2 = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Option 2',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue[900],
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: op3clr,
                      validator: (val) => val.isEmpty ? 'Option 3 required' : null,
                      onChanged: (val) {
                        setState(() {
                          option3 = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Option 3',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue[900],
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: op4clr,
                      validator: (val) => val.isEmpty ? 'Option 4 required' : null,
                      onChanged: (val) {
                        setState(() {
                          option4 = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Option 4',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue[900],
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        SizedBox(width: 60.0),
                        RaisedButton(
                          color: Colors.blue[900],
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              quizID = widget.quizid;
                            });

                            await uploadQuizData();
                            if (_formkey.currentState.validate()) {
                              await DatabaseService(uid: streamDataabtUser.uid)
                                  .addMyRoomData(widget.quizid, widget.roomname, widget.roomtype);
                              //cyutcytjhgvh
                              await navToCopyScreen();
                            }
                          },
                        ),
                        SizedBox(width: 40.0),
                        RaisedButton(
                          color: Colors.blue[900],
                          child: Text(
                            'Add Question',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              quizID = widget.quizid;
                            });

                            await uploadQuizData();
                            clearTxtInput();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
