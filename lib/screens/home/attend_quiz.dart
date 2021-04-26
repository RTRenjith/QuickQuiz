import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_quiz/models/ques_model_to_list_builder_model.dart';
import 'package:quick_quiz/models/ques_snap.dart';
import 'package:quick_quiz/models/question_model.dart';
import 'package:quick_quiz/screens/home/result.dart';
import 'package:quick_quiz/services/database.dart';
import 'package:quick_quiz/services/db_to_our_model_inJoinRoom.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:quick_quiz/shared/loading.dart';
import 'package:quick_quiz/shared/option_tile.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/models/user.dart';


class QuizPage extends StatefulWidget {

  final String quizid;
  QuizPage({this.quizid});

  @override
  _QuizPageState createState() => _QuizPageState();
}

int total = 0;
int correct = 0;
int incorrect = 0;
int notattempted = 0;

class _QuizPageState extends State<QuizPage> {

Rooms roomservice = new Rooms();
DbtoUr dbtoUr = new DbtoUr();
String username = '';
List<QuestionSnap> quesObj;
List<QuestionModel> quesWeWanted = [];
int tot;

QuestionModelWeWant getQuestionModelWeWant(
    QuestionModel quesWeWanted ) {
  QuestionModelWeWant questionModelWeWant = new QuestionModelWeWant();

  questionModelWeWant.question = quesWeWanted.question;
  /// shuffling the options
  List<String> options = [
    quesWeWanted.option1,
    quesWeWanted.option2,
    quesWeWanted.option3,
    quesWeWanted.option4,
  ];
  options.shuffle();
  print(options);

  questionModelWeWant.option1 = options[0];
  questionModelWeWant.option2 = options[1];
  questionModelWeWant.option3 = options[2];
  questionModelWeWant.option4 = options[3];
  questionModelWeWant.correctans = quesWeWanted.option1;
  questionModelWeWant.isAnswered = false;

  print(questionModelWeWant.correctans.toLowerCase());

  return questionModelWeWant;
}
abc(){

  quesWeWanted.shuffle();
}

  Future start() async {
    quesObj =  await roomservice.getQuizData(widget.quizid);
    print(quesObj);
    await dbtoUr.temp(quesObj).then((value) => quesWeWanted = value);
    setState(() {
      tot = quesWeWanted.length;
    });
    notattempted = 0;
    correct = 0;
    incorrect = 0;
    total = tot;
    abc();
  }


@override
  void initState() {
      start();
      Fluttertoast.showToast(msg: 'Answer once chosen cannot be modified!', backgroundColor: Colors.black);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final streamDataabtUser = Provider.of<CustomUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: streamDataabtUser.uid).customuserdata,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.0,
              title: Text("QuickQuiz"),
              backgroundColor: Colors.blue[900],
            ),
            body: Container(
              child:SingleChildScrollView(
                child: Column(
                  children: [
                    quesWeWanted == null ?
                    Container() :
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: quesWeWanted.length,
                      itemBuilder: (context,index){
                        return QuizPlayTile(
                          questionModelWeWant : getQuestionModelWeWant(quesWeWanted[index]),
                          index: index,
                        );
                      },

                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[900],
              child: Icon(Icons.check),
              onPressed: () async {
                String res = '$correct/$total';
                await DatabaseService().getusername(streamDataabtUser.uid).then((value) => username = value);
                roomservice.addAttemptData(username, widget.quizid, res);

                await DatabaseService(uid: streamDataabtUser.uid).addAttemptedRoomData(widget.quizid,res);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) =>Results(
                      correct: correct,
                      incorrect: incorrect,
                      total: total,
                    )
                )
                );
              },
            ),
          );
        }else{
          return Loading();
        }
      }

    );
  }
}

class QuizPlayTile extends StatefulWidget {

  final QuestionModelWeWant questionModelWeWant;
  final int index;
  QuizPlayTile({
    this.questionModelWeWant,
    this.index
});
  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {

  String optionSelected = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0,),
          Text("(Q${widget.index+1}) ${widget.questionModelWeWant.question}", style: TextStyle(fontSize: 18, color: Colors.black87),),
          SizedBox(height: 12),
          GestureDetector(
            onTap: (){
              if (!widget.questionModelWeWant.isAnswered) {
                ///correct
                if (widget.questionModelWeWant.option1 ==
                    widget.questionModelWeWant.correctans) {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option1;
                    widget.questionModelWeWant.isAnswered = true;
                    correct = correct + 1;
                    notattempted = notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option1;
                    widget.questionModelWeWant.isAnswered = true;
                    incorrect = incorrect + 1;
                    notattempted = notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option1,
              option: 'A',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: (){
              if (!widget.questionModelWeWant.isAnswered) {
                ///correct
                if (widget.questionModelWeWant.option2 ==
                    widget.questionModelWeWant.correctans) {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option2;
                    widget.questionModelWeWant.isAnswered = true;
                    correct = correct + 1;
                    notattempted = notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option2;
                    widget.questionModelWeWant.isAnswered = true;
                    incorrect = incorrect + 1;
                    notattempted = notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option2,
              option: 'B',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: (){
              if (!widget.questionModelWeWant.isAnswered) {
                ///correct
                if (widget.questionModelWeWant.option3 ==
                    widget.questionModelWeWant.correctans) {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option3;
                    widget.questionModelWeWant.isAnswered = true;
                    correct = correct + 1;
                    notattempted = notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option3;
                    widget.questionModelWeWant.isAnswered = true;
                    incorrect = incorrect + 1;
                    notattempted = notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option3,
              option: 'C',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: (){
              if (!widget.questionModelWeWant.isAnswered) {
                ///correct
                if (widget.questionModelWeWant.option4 ==
                    widget.questionModelWeWant.correctans) {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option4;
                    widget.questionModelWeWant.isAnswered = true;
                    correct = correct + 1;
                    notattempted = notattempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModelWeWant.option4;
                    widget.questionModelWeWant.isAnswered = true;
                    incorrect = incorrect + 1;
                    notattempted = notattempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option4,
              option: 'D',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}

