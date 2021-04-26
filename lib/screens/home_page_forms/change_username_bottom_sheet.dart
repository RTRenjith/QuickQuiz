import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/services/database.dart';
import 'package:quick_quiz/shared/loading.dart';

class ChangeUsernameBottomSheet extends StatefulWidget {

  @override
  _ChangeUsernameBottomSheetState createState() => _ChangeUsernameBottomSheetState();
}

class _ChangeUsernameBottomSheetState extends State<ChangeUsernameBottomSheet> {
  final _formkey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();

  String roomname = '';
  String quizID = '';
  String username = " ";


  @override
  Widget build(BuildContext context) {

    final streamDataabtUser = Provider.of<CustomUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: streamDataabtUser.uid).customuserdata,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userdata = snapshot.data;
          return Form(
            key: _formkey,
            child: Column(
              children: [
                Text(
                  'Enter Username',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  initialValue: userdata.name,
                  validator: (val) => val.isEmpty ? 'Username required' : null,
                  onChanged: (val) {
                    setState(() {
                      username = val;
                    });
                  },

                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue[900],
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.blue[900],
                  child: Text(
                    'Change Username',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      await DatabaseService(uid: streamDataabtUser.uid).addUserData(username ?? userdata.name);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }else{
          return Loading();
        }

      }
    );
  }
}
