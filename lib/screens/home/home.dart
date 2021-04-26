import 'package:flutter/material.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/screens/home/attended_rooms.dart';
import 'package:quick_quiz/screens/home/my_rooms.dart';
import 'package:quick_quiz/services/auth.dart';
import 'package:quick_quiz/screens/home_page_forms/create_room_bottom_sheet.dart';
import 'package:quick_quiz/screens/home_page_forms/join_room_bottom_sheet.dart';
import 'package:quick_quiz/screens/home_page_forms/change_username_bottom_sheet.dart';
import 'package:quick_quiz/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _showCreateRoomBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: CreateRoomBottomSheet(),
          );
        });
  }

  void _showJoinRoomBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: JoinRoomSheet(),
          );
        });
  }

  void _showChangeUsernameBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: ChangeUsernameBottomSheet(),
          );
        });
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    final streamDataabtUser = Provider.of<CustomUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: streamDataabtUser.uid).customuserdata,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            title: Text('Quick Quiz'),
            backgroundColor: Colors.blue[900],

            elevation: 0.0,
            actions: [
              IconButton(
                onPressed: () async {
                  return _showChangeUsernameBottomSheet();
                },
                icon: Icon(Icons.settings),
              ),
              FlatButton.icon(
                onPressed: () async {
                  await _authService.signOut();
                },
                label: Text('Logout',
                style: TextStyle(
                  color: Colors.white,
                ),),
                icon: Icon(Icons.logout,
                color: Colors.white,),

              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () async {
                       return _showCreateRoomBottomSheet();
                    },
                    child: Text(
                      'Create Room',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 60.0),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      return _showJoinRoomBottomSheet();
                    },
                    child: Text(
                      'Join Room',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 60.0),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>MyRooms(uid: streamDataabtUser.uid)
                      )
                      );
                    },
                    child: Text(
                      'My Quiz Rooms',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 60.0),
                ButtonTheme(
                  minWidth: 500.0,
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>AttendedRooms(uid: streamDataabtUser.uid)
                      )
                      );
                    },
                    child: Text(
                      'Attended Quiz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
