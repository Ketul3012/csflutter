import 'package:csflutter/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  static void setType(bool type) async
  {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("logged", type);
      pref.commit();
      print("Set Type");
  }
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance ;
  String email = "";
  String password = "";
  
  @override
  void initState()  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(accentColor: Colors.blue , primarySwatch: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Login"),
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
                    margin: EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value){
                        email = value;
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
                      hintText: "User email",
                    ),
                  ),
                  ),
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (val){
                        password = val;
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
                      hintText: "User Password",
                    ),
                  ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      if (_formKey.currentState.validate()){
                        
                        dynamic result = _auth.signInWithEmailAndPassword(email: email, password: password).then((val){
                          if (val.additionalUserInfo != null)
                          {
                            print(val.additionalUserInfo);
                            Login.setType(true);
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Mainscreen()));
                          }
                        });
                        if (result is Future<Null>)
                        {
                          Fluttertoast.showToast(msg: "Enter Valid Information"
                          ,toastLength: Toast.LENGTH_SHORT ,
                          timeInSecForIos: 2 ,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white ,
                          gravity: ToastGravity.BOTTOM);
                        }
                      }
                    },
                    textColor: Colors.white,
                    child: Text("Login"),
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