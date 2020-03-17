
import 'dart:io';

import 'package:csflutter/camera_screen.dart';
import 'package:csflutter/home.dart';
import 'package:csflutter/login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Mainscreen extends StatefulWidget {
  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  final _auth = FirebaseAuth.instance; 

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onBackClick()
    {
      return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('Are you sure?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(accentColor: Colors.blue , primarySwatch: Colors.blue),
        home: WillPopScope(
          child:Scaffold(
          appBar: AppBar(
            title: Text("Clean Street"),
            leading: BackButton(
                color: Colors.white,
                onPressed: onBackClick,
              ),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: (choice){
                    if (choice == "Logout")
                    {
                      Login.setType(false);
                      _auth.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homescreen()));
                    }
                 },
                itemBuilder:(context){
                  var list = ["Logout" , "Setting"];
                  return list.map((f)  {
                    return PopupMenuItem<String>(
                      value : f,
                      child: Text(f),
                    );
                  }).toList();
                } ,
              )
            ],
          ),
         body: Camerascreen()
        ), 
         onWillPop: onBackClick)
    );

  }
}