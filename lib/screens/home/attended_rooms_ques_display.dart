import 'package:flutter/material.dart';
import 'package:quick_quiz/models/ques_model_to_list_builder_model.dart';
import 'package:quick_quiz/models/ques_snap.dart';
import 'package:quick_quiz/models/question_model.dart';
import 'package:quick_quiz/services/db_to_our_model_inJoinRoom.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:quick_quiz/shared/option_tile.dart';

class MyRoomPageinAttended extends StatefulWidget {

  final String quizid;
  MyRoomPageinAttended({this.quizid});

  @override
  _MyRoomPageinAttendedState createState() => _MyRoomPageinAttendedState();
}


class _MyRoomPageinAttendedState extends State<MyRoomPageinAttended> {

  Rooms roomservice = new Rooms();
  DbtoUr dbtoUr = new DbtoUr();
  List<QuestionSnap> quesObj;
  List<QuestionModel> quesWeWanted = [];

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
    });

    abc();
  }


  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option1,
              option: 'A',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(

            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option2,
              option: 'B',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option3,
              option: 'C',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(

            child: OptionTile(
              crtAns: widget.questionModelWeWant.correctans,
              ansOptions: widget.questionModelWeWant.option4,
              option: 'D',
              optSel: optionSelected,
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            child: Text(
                'Correct answer: ${widget.questionModelWeWant.correctans}'
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}

