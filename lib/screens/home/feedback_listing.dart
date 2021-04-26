import 'package:flutter/material.dart';
import 'package:quick_quiz/models/FeedbackAttemptsModel.dart';
import 'package:quick_quiz/services/roomhandling.dart';

class FeedbackListing extends StatefulWidget {

  final String quizid;
  FeedbackListing({this.quizid});
  @override
  _FeedbackListingState createState() => _FeedbackListingState();
}

class _FeedbackListingState extends State<FeedbackListing> {

  Rooms roomservice = new Rooms();
  List<FeedbackAttemptsModel> feedbackData=[];

  Future<List<FeedbackAttemptsModel>> _getfeedbackdata() async {
    print("inside api call");
    List<FeedbackAttemptsModel> li =  await roomservice.getFeedbackAttemptsData(widget.quizid).then((value) => feedbackData = value);
    return li;
  }

  Future start() async {
    feedbackData = await _getfeedbackdata();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  Widget feedbackattemptlist(){
    print('inside widget');
    return FutureBuilder(
      future: _getfeedbackdata(),
      builder: (context, AsyncSnapshot snapshot){
        if(feedbackData.isEmpty){
          return Container(
            child: Center(
              child: Text("There are no attempts in this room",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),),
            ),
          );
        }
        return ListView.builder(
          itemCount: feedbackData.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                leading: Text(feedbackData[index].rating.toString(),style: TextStyle(fontSize: 18.0),),
                title: Text(feedbackData[index].feedback, style: TextStyle(fontSize: 17.0),),
                //subtitle: Text(feedback_data[index].score),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attempts'),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[900],
      ),
      body: feedbackattemptlist(),
    );
  }
}
