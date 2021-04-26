import 'package:flutter/material.dart';
import 'package:quick_quiz/models/attempts_model.dart';
import 'package:quick_quiz/services/roomhandling.dart';

//ignore: must_be_immutable
class Attempts extends StatefulWidget {
  String roomid;
  Attempts({this.roomid});
  @override
  _AttemptsState createState() => _AttemptsState();
}

class _AttemptsState extends State<Attempts> {

  Rooms roomservice = new Rooms();

  List<AttemptsModel> myroomAttemptsObj =[];

  Future start() async {
    print('start');
    await roomservice.getAttemptsData(widget.roomid).then((value) => myroomAttemptsObj = value);
    print(myroomAttemptsObj[0].username);
    setState(() {

    });
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  Widget myroomattemptlist(){
    print('inside widget');
    return FutureBuilder(
      builder: (context, myroomObj){
        if(myroomAttemptsObj.isEmpty){
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
          itemCount: myroomAttemptsObj.length,
          itemBuilder: (context, index){
            return Card(
              child: ListTile(
                leading: Text(myroomAttemptsObj[index].score,style: TextStyle(fontSize: 18.0),),
                title: Text(myroomAttemptsObj[index].username, style: TextStyle(fontSize: 17.0),),
                //subtitle: Text(myroomAttemptsObj[index].score),
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
      body: myroomattemptlist(),
    );
  }
}
