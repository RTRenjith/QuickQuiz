import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_quiz/models/user.dart';
import 'package:quick_quiz/screens/authenticate/authenticate.dart';
import 'package:quick_quiz/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final streamDataabtUser = Provider.of<CustomUser>(context);

    if (streamDataabtUser == null) {
      return Authenticate();
    }else if (streamDataabtUser.isverified == false) {
      return Authenticate();
    }else if(streamDataabtUser.isverified == true){
      return Home();
    }
  }
}
