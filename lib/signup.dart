
import 'package:csflutter/login.dart';
import 'package:csflutter/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
    final _formKey = GlobalKey<FormState>();
    final List<DropdownMenuItem<String>> type = [DropdownMenuItem(value: "User",child: Text("User"),) ,DropdownMenuItem(value: "Sweeper",child: Text("Sweeper"),) ];
    final _auth = FirebaseAuth.instance ;
    var ref = FirebaseDatabase.instance.reference();
    String email = "";
    String password = "";
    String firstname = "";
    String lastname = "";
    String usertype = "User";

  void changedropDown(String selectedtype)
    {
      setState(() {
        usertype = selectedtype;
      });
    }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(accentColor: Colors.blue , primarySwatch: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Register"),
          ),
          body: Container(
          color: Colors.blue[10],
          child: Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Card(
              color: Colors.white,
              child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(6.0),
                    child: TextFormField(
                      onChanged: (val) => {
                        firstname = val
                      },
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter firstname';
                         }
                        return null;},
                    decoration: InputDecoration(
                      hintText: "Enter First Name",
                    ),
                  ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(6.0),
                    child: TextFormField(
                      onChanged: (val) => {
                        lastname = val
                      },
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter lastname';
                         }
                        return null;},
                    decoration: InputDecoration(
                      hintText: "Enter Last Name",
                    ),
                  ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(6.0),
                    child: TextFormField(
                      onChanged: (val) => {
                        email = val
                      },
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                         }
                         if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                          return "Please Enter Valid Email";
                        } 
                        return null;},
                    decoration: InputDecoration(
                      hintText: "Enter email",
                    ),
                  ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(6.0),
                    child: TextFormField(
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                         }
                        if (value.length < 8)
                        {
                          return "Password length must be 8+ character long";
                        }
                        return null;},
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                    ),
                  ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(6.0),
                    child: TextFormField(
                    onChanged: (val) => {
                        password = val
                      },
                    validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password';
                         }
                        if (value.length < 8)
                        {
                          return "Password length must be 8+ character long";
                        }
                        return null;},
                    decoration: InputDecoration(
                      hintText: "Re-Enter Password",
                    ),
                  ),
                  ),
                  DropdownButton(value: usertype, items: type, onChanged: changedropDown),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        dynamic result = _auth.createUserWithEmailAndPassword(email: email, password: password);
                        if (result != null)
                        {   final FirebaseUser uid = await _auth.currentUser();
                            var user = User(firstname, lastname, uid.uid , password, usertype);
                            print(ref.path);
                            ref = ref.child("Users").child(uid.uid);
                            print(ref.path);
                            ref.set(user);
                            Fluttertoast.showToast(msg: "Regestration Suceed , please login"
                          ,toastLength: Toast.LENGTH_SHORT ,
                          timeInSecForIos: 2 ,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white ,
                          gravity: ToastGravity.BOTTOM);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));

                        }else{
                          Fluttertoast.showToast(msg: "Regestration Failed"
                          ,toastLength: Toast.LENGTH_SHORT ,
                          timeInSecForIos: 2 ,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white ,
                          gravity: ToastGravity.BOTTOM);
                        }
                      }
                    },
                    textColor: Colors.white,
                    child: Text("Register"),
                    color: Theme.of(context).accentColor,)
                ],
            )
            ),
          )
            ],
          )
      ),
    ),
    )
    );

    
  }
}