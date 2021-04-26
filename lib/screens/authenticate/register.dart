import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_quiz/shared/loading.dart';
import 'package:quick_quiz/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  // Future sendverificationmail() async {
  //   User user = await FirebaseAuth.instance.currentUser;
  //   user.sendEmailVerification();
  // }
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();

  //text field state
  String username ='';
  String email = '';
  String password = '';
  String confirmpassword = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              elevation: 0.0,
              title: Text('Quick Quiz'),
              centerTitle: true,
              actions: [
                TextButton.icon(
                  icon: Icon(Icons.login_rounded,color: Colors.white,),
                  label: Text('Sign In',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    setState(() {
                      widget.toggleView();
                    });
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(50.0, 60.0, 50.0, 0.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => val.isEmpty ? 'Username required' : null,
                        onChanged: (val) {
                          setState(() {
                            username = val;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.perm_identity_sharp),
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900],
                              width: 2.0,

                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => val.isEmpty ? 'Email required' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900],
                              width: 2.0,

                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => val.length < 6
                            ? 'Must be atleast 6 chars long'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900],
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => val != password
                            ? 'password mismatch'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            confirmpassword = val;
                          });
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue[900],
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ButtonTheme(
                        minWidth: 200.0,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _authService
                                  .registerwithEmailandPassword(email, password, username);
                            if(result != null) {
                              Fluttertoast.showToast(msg: 'Email registered! Please check email for verification', backgroundColor: Colors.black);
                              setState(() {
                                error = '';
                                loading = false;
                              });
                            }
                              if (result == null) {
                                setState(() {
                                  error = 'Please supply a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
