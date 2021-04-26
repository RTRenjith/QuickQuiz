import 'package:flutter/material.dart';
import 'package:quick_quiz/models/myroom_model.dart';
import 'package:quick_quiz/screens/home/feedback_listing.dart';
import 'package:quick_quiz/screens/home/my_rooms_ques_data.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:quick_quiz/shared/loading.dart';

//ignore: must_be_immutable
class MyRooms extends StatefulWidget {
  String uid;
  MyRooms({this.uid});
  @override
  _MyRoomsState createState() => _MyRoomsState();
}

class _MyRoomsState extends State<MyRooms> {

  Rooms roomservice = new Rooms();
  List<MyRoomModel> myroomsObj=[];
  List<MyRoomModel> feedbackList=[];
  List<MyRoomModel> quizList=[];

  Future<List<MyRoomModel>> _getfeedback() async {
   List<MyRoomModel> li =  await roomservice.getMyRoomFeedbackData(widget.uid);
   return li;
  }

  Future<List<MyRoomModel>> _getquiz() async {
    List<MyRoomModel> li =  await roomservice.getMyRoomQuizData(widget.uid);
    return li;
  }

  Future start() async {
    quizList = await _getquiz();
    feedbackList = await _getfeedback();
    setState(() {});
  }



  @override
  void initState() {
    super.initState();
    start();
  }

  Widget myfeedbacklist() {
    return FutureBuilder(
      future: _getfeedback(),
      builder: (context, AsyncSnapshot snapshot) {
        if (feedbackList.isEmpty) {
          return Container(
            child: Center(
              child: Text(
                'There is no Feedbacks available',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: feedbackList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          FeedbackListing(
                            quizid: feedbackList[index].roomID,
                          )
                  ));
                  print('clicked');
                },
                title: Text(feedbackList[index].roomName),
                subtitle: Text(feedbackList[index].roomID),
              ),
            );
          },
        );
      },
    );
  }

  Widget myquizlist() {
    return FutureBuilder(
      future: _getquiz(),
      builder: (context, AsyncSnapshot snapshot) {
        if (quizList.isEmpty) {
          return Container(
            child: Center(
              child: Text(
                'There is no rooms available',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: quizList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          MyRoomPage(
                            quizid: quizList[index].roomID,
                          )
                  ));
                  print('clicked');
                },
                title: Text(quizList[index].roomName),
                subtitle: Text(quizList[index].roomID),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Quiz"),
                Tab(text: "Feedback"),
              ],
            ),
            title: Text("My Rooms"),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.blue[900],
          ),
          body: TabBarView(
            children: [
              myquizlist(),
              myfeedbacklist(),
            ],
          ),
        ),
      ),
    );
  }
}
