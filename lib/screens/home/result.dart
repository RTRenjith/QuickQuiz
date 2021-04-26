import 'package:flutter/material.dart';

class Results extends StatefulWidget {

  final int correct, incorrect, total;
  Results({@required this.incorrect, @required this.correct,@required this.total});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${widget.correct}/${widget.total}" , style: TextStyle(fontSize: 25),),
              SizedBox(height: 8,),
              Text("You have answered ${widget.correct} answers correctly"
                  " and ${widget.incorrect} answers incorrectly",
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                  textAlign: TextAlign.center,
              ),
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
