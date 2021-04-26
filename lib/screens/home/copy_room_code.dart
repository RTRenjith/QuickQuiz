import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share/share.dart';

//ignore: must_be_immutable
class CopyCode extends StatefulWidget {

  String roomname = '';
  String quizid = '';
  CopyCode({Key key, @required this.roomname, this.quizid})
      : super(key: key);

  @override
  _CopyCodeState createState() => _CopyCodeState();
}

class _CopyCodeState extends State<CopyCode> {

  String widgetRoomname = '';
  String widgetquizid = '';


  @override
  Widget build(BuildContext context){
    widgetRoomname = widget.roomname;
    widgetquizid = widget.quizid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '$widgetRoomname',
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height:250.0 ,),
            Text('Your Quiz room has been created',style: TextStyle(fontSize: 16.0,color: Colors.grey[900]),),
            SizedBox(height: 5.0),
            Text('$widgetquizid',style: TextStyle(fontSize: 24.0,color: Colors.black),),
            Row(
              children: [

                SizedBox(width: 75.0),
                TextButton.icon(
                  icon: Icon(Icons.copy),
                  label: Text('Copy to Clipboard'),
                  onPressed: () {
                    FlutterClipboard.copy(widgetquizid);
                  },
                ),
                TextButton.icon(
                  icon: Icon(Icons.share_sharp),
                  label: Text('Share'),
                  onPressed: () async {
                    try {
                      await Share.share('$widgetquizid');
                      print(widgetquizid);
                    }catch(e){
                      print(e.toString());
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            ButtonTheme(
              minWidth: 200.0,
              height: 50.0,
              child: RaisedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Go Home',style: TextStyle(color: Colors.white),),
                color: Colors.blue[900],
              ),
            )
          ],
        ),
      ),
    );
  }
}
