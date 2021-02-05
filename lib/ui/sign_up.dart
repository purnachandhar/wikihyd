import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Future<Users> _createUser;

  final TextEditingController _firstnamecontroller = TextEditingController();
  final TextEditingController _lastNamecontroller = TextEditingController();
  final TextEditingController _emailIdcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _contactnumbercontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_createUser == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _firstnamecontroller,
                    decoration: InputDecoration(hintText: 'Enter FirstName'),
                  ),
                  TextField(
                    controller: _lastNamecontroller,
                    decoration: InputDecoration(hintText: 'Enter LastName'),
                  ),
                  TextField(
                    controller: _emailIdcontroller,
                    decoration: InputDecoration(hintText: 'Enter Email'),
                  ),
                  TextField(
                    controller: _passwordcontroller,
                    decoration: InputDecoration(hintText: 'Enter Password'),
                  ),
                  TextField(
                    controller: _contactnumbercontroller,
                    decoration: InputDecoration(hintText: 'Enter Mobile Number'),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          print("${_firstnamecontroller.text}");
                          _createUser = createAccount(_firstnamecontroller.text,_lastNamecontroller.text,_emailIdcontroller.text,_passwordcontroller.text,_contactnumbercontroller.text);
                        });
                      },
                      child: Text("Register"))
                ],
              )
            : FutureBuilder(
                future: _createUser,
                builder: (context, snapshort) {
                  if (snapshort.hasData) {
                    return Text(snapshort.data.firstName);
                  } else if (snapshort.hasError) {
                    return Text("the main problom is ${snapshort.error}");
                  }
                  return CircularProgressIndicator();
                },
              ),
      ),
    );
  }
}

// this method is used to create an account

Future<Users> createAccount(
  String firstName,
  String lastName,
  String emailId,
  String password,
  String contactnumber,
) async {
  var url =
      'http://rdsex-env.eba-rbwhmti7.ap-south-1.elasticbeanstalk.com/user/register';
  final response = await http.post(
    url,
    body: {
      'firstName': firstName,
      'lastName': lastName,
      'emailId': emailId,
      'password': password,
      'contactnumber': contactnumber,
    }
   /* body: jsonEncode(<String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'emailId': emailId,
      'password': password,
      'contactnumber': contactnumber,
    }),*/
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Users.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// this is the pojo class for signUp userr
class Users {
  final String firstName;
  final String lastName;
  final String emailId;
  final String password;
  final String contactnumber;

  Users(
      {this.firstName,
      this.lastName,
      this.emailId,
      this.password,
      this.contactnumber});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      firstName: json['firstName'],
      lastName: json['lastName'],
      emailId: json['emailId'],
      password: json['password'],
      contactnumber: json['contactnumber'],
    );
  }
}
