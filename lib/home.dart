
import 'package:csflutter/signup.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:permission_handler/permission_handler.dart';


class Homescreen extends StatelessWidget {

  Homescreen({Key key}) : super(key: key);
  
  static final PermissionHandler _permissionHandler = PermissionHandler();

  static Future<bool> requestPermission() async {
    var result = await _permissionHandler.requestPermissions([PermissionGroup.locationWhenInUse , PermissionGroup.camera]);
    if (result[PermissionGroup.camera] == PermissionStatus.granted && result[PermissionGroup.locationWhenInUse]== PermissionStatus.granted) {
      return true;
    }
    return false;
  }
  
  static Future<bool> hasPermission() async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(PermissionGroup.locationWhenInUse);
    var permissionStatus1 =
        await _permissionHandler.checkPermissionStatus(PermissionGroup.camera);
    return permissionStatus == PermissionStatus.granted && permissionStatus1 == PermissionStatus.granted;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(accentColor: Colors.blue , primarySwatch: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Clean Street"),
          ),
          body: Container(
          color: Colors.white,
          child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  if (!await hasPermission())
                  {
                    requestPermission();
                  } 
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                  },
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text("Login")),
              RaisedButton(
                onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => Signup()));},
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child:Text("Register") )
          ],
        ),
      ),
    ),
    )
    );
  }
}