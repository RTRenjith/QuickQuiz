import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_quiz/shared/loading.dart';
import 'package:quick_quiz/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

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
                  icon: Icon(Icons.account_circle_outlined,color: Colors.white,),
                  label: Text('Register',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.fromLTRB(50.0, 200.0, 50.0, 0.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Email required' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline_sharp),
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
                          ? 'Incorrect password'
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
                    ButtonTheme(
                      minWidth: 200.0,
                      height: 50.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                        child: Text(
                          'Sign in',
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
                                .signInwithEmailandPassword(email, password);
                              setState(() {

                              });
                            if (result == null) {
                              print('inside null');
                              setState(() {
                                error = "Email or Password doesn't exist";
                                loading = false;
                              });
                            }else if(result.isverified == false){
                              Fluttertoast.showToast(msg: "Please verify your email before signing in",backgroundColor: Colors.black);
                              setState(() {
                                error='';
                                loading = false;
                              });

                            }else if(result.isverified == true) {
                              await _authService.signOut();
                              await _authService
                                  .signInwithEmailandPassword(email, password);
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                          }

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
          );
  }
}
