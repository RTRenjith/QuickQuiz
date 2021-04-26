import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/models/attended_rooms_model.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/screens/home/attended_rooms_ques_display.dart';
import 'package:quick_quiz/services/database.dart';
import 'package:quick_quiz/services/roomhandling.dart';

//ignore: must_be_immutable
class AttendedRooms extends StatefulWidget {
  String uid;
  AttendedRooms({this.uid});
  @override
  _AttendedRoomsState createState() => _AttendedRoomsState();
}

class _AttendedRoomsState extends State<AttendedRooms> {
  Rooms roomservice = new Rooms();

  List<AttemptedRoomsModel> attemptedroomsObj =[];

  Future start() async {
    print("START");
    await roomservice.getAttempedRoomData(widget.uid).then((value) => attemptedroomsObj = value
    );
    print(attemptedroomsObj);

    setState(() {

    });
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  Widget attendedroomslist(){
    return FutureBuilder(
      builder: (context, roomnameObj){
        if(attemptedroomsObj.isEmpty){
          return Container(
            child: Center(
              child: Text("You haven't attempted any quiz",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),),
            ),
          );
        }
        return ListView.builder(
          itemCount: attemptedroomsObj.length,
          itemBuilder: (context, index){
            print(index);
            return Card(
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MyRoomPageinAttended(
                        quizid: attemptedroomsObj[index].roomid,
                      )
                  ));
                  print('clicked');
                },
                leading: Text(attemptedroomsObj[index].score,style: TextStyle(
                  fontSize: 18.0,
                ),),
                title: Text(attemptedroomsObj[index].roomname),
              subtitle: Text(attemptedroomsObj[index].roomid),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final streamDataabtUser = Provider.of<CustomUser>(context);
    return StreamBuilder(
      stream: DatabaseService(uid: streamDataabtUser.uid).customuserdata,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Attended Rooms'),
              backgroundColor: Colors.blue[900],
            ),
            body: attendedroomslist(),
          );

        }
    );
  }
}
