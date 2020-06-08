import 'package:covidtracker/screens/Home.dart';
import 'package:covidtracker/screens/Register.dart';
import 'package:flutter/material.dart';

import '../services/AuthService.dart';
import 'Home.dart';
import 'Register.dart';

import 'package:geolocator/geolocator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email ="";
  String pass = "";
  static double lat;
  static double long;

  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();
  String error = '';

  /*void _getCurrentLocatin() async {
    final position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      lat=position.latitude;
      long=position.longitude;
    });
    print("lat and long");
    print(lat);
    print(long);
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("COVID-19 Tracker"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () { print("Register");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Register())); } ,
              icon: Icon(Icons.person),
              label: Text("Register"))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/covid.png'),
              SizedBox(height: 40.0,),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.white,
                  hintText: "Email",
                  filled: true,
                ),
                onChanged: (val){
                  setState(() {
                    email=val;
                  });
                },
                validator: (val) => val.isEmpty ? "Entrer Email":null,
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Colors.white,
                  hintText: "Password",
                  filled: true,
                ),
                onChanged: (val){
                  setState(() {
                    pass=val;
                  });
                },
                validator: (val) => val.length<6 ? "Entrer password 6+  chars":null,
              ),
              SizedBox(height: 40.0,),
              RaisedButton(
                color: Colors.pink[500],
                textColor: Colors.white,
                child: Text("Sign IN"),
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    print("ok");
                    print(email);
                    print(pass);
                    //dynamic result = await _auth.signInAnom();
                    dynamic result = await _auth.signInWithEmailAndPassword(
                        email, pass);
                    if (result == null) {
                      print('error SignIn!!!');
                      setState(() {
                        error = 'Error SignIn!!!';
                      });
                    }
                    else {
                      print('Sign In Ok !');
                      print(result.uid);
                      //_getCurrentLocatin();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
