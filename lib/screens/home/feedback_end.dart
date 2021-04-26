import 'package:flutter/material.dart';

class FeedbackEnd extends StatefulWidget {
  @override
  _FeedbackEndState createState() => _FeedbackEndState();
}

class _FeedbackEndState extends State<FeedbackEnd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your Feedback has been recorded!" , style: TextStyle(fontSize: 17),),
              SizedBox(height: 8,),

              SizedBox(height: 14,),
              ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                  elevation: 0.0,
                  child: Text("Go to Home",
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  color: Colors.blue[900],
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
