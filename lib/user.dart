import 'package:dataclass/dataclass.dart';

@dataClass
class User {
  final  String firstname;
  final  String lastname;
  final  String uid; 
  final String password;
  final String type;

  User(this.firstname , this.lastname , this.uid , this.password , this.type){}

}