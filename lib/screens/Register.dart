import 'package:flutter/material.dart';
import '../services/AuthService.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String fullname ="";
  String phonenum = "";
  String email ="";
  String pass = "";
  String age = "";
  String ville = "";

  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("Register COVID-19 Tracker"),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Sign UP',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 40.0,),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.white,
                    hintText: "Full Name",
                    filled: true,
                  ),
                  onChanged: (val){
                    setState(() {
                      fullname=val;
                    });
                  },
                  validator: (val) => val.isEmpty ? "Entrer Full name":null,
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_phone),
                    fillColor: Colors.white,
                    hintText: "Phone Number",
                    filled: true,
                  ),
                  onChanged: (val){
                    setState(() {
                      phonenum=val;
                    });
                  },
                  validator: (val) => val.isEmpty ? "Entrer Phone Number":null,
                ),
                //Image.asset('assets/images/covid.png'),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.alternate_email),
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
                  validator: (val) => val.length<6 ? "Entrer your password +6":null,
                ),
                SizedBox(height: 20.0,),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.event),
                        fillColor: Colors.white,
                        hintText: "Age",
                        filled: true,
                      ),
                      onChanged: (val){
                        setState(() {
                          age=val;
                        });
                      },
                      validator: (val) => val.isEmpty ? "Entrer your age please":null,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        fillColor: Colors.white,
                        hintText: "Ville",
                        filled: true,
                      ),
                      onChanged: (val){
                        setState(() {
                          ville=val;
                        });
                      },
                      validator: (val) => val.isEmpty ? "Entrer your city please":null,
                    ),
                  )
                ]),
                SizedBox(height: 40.0,),
                RaisedButton(
                  color: Colors.pink[500],
                  textColor: Colors.white,
                  child: Text("Sign UP"),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      print("ok");
                      print(email);
                      print(pass);
                      dynamic result = await _auth.registerWithEmailAndPassword(email, pass, fullname, phonenum, int.parse(age) , ville);
                      if(result == null) {
                        setState(() {
                          error = 'Please enter a valid email';
                        });
                      } else{
                        Navigator.pop(context);
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
      ),
    );
  }
}
