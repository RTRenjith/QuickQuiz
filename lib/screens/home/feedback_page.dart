import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:quick_quiz/services/roomhandling.dart';
import 'package:quick_quiz/screens/home/feedback_end.dart';

class FeedbackForm extends StatefulWidget {

  final String quizid;
  FeedbackForm({this.quizid});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formkey = GlobalKey<FormState>();

  final feedbacktxt = TextEditingController();
  Rooms roomservice = new Rooms();
  String feedback = '';
  double ratingInput=3;

  uploadFeedback() async {
    if (_formkey.currentState.validate()) {
      roomservice.addFeedbackAttemptData(widget.quizid, feedback, ratingInput);

      // await DatabaseService(uid: streamDataabtUser.uid).addAttemptedRoomData(widget.quizid,res);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => FeedbackEnd()
      )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: SingleChildScrollView(
          child: Form(

            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                TextFormField(
                  maxLines: 15,
                  controller: feedbacktxt,
                  validator: (val) => val.isEmpty ? 'Feedback required' : null,
                  onChanged: (val) {
                    setState(() {
                      feedback = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Give your Feedback',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue[900],
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
            RatingBar.builder(
              initialRating: 3,
              itemCount: 5,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );

                }
              },
              onRatingUpdate: (rating) {
                setState(() {
                  ratingInput = rating;
                });
              },
            ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.check),
        onPressed: () async {
          uploadFeedback();
        },
      ),
    );
  }
}
