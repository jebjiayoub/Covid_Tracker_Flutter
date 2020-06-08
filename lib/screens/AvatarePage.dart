import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:covidtracker/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:covidtracker/services/Uploader.dart';
import 'package:http/http.dart' as http;

class Avatar extends StatefulWidget {
  @override
  _AvatarePageState createState() => _AvatarePageState();
}

class _AvatarePageState extends State<Avatar> {

  Uint8List imageFile;
  String url;
  File _imageF;

  @override
  void initState() {
    String filePath='images/${AuthService.userId.toString()}.png';
    final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://covidtrackerflutter.appspot.com');
    int MAX_SIZE = 7*1024*1024;
    _storage.ref().child(filePath).getData(MAX_SIZE).then((data) => {
      this.setState(() {
        imageFile = data;
        _imageF = File.fromRawPath(imageFile);
      })
    }).catchError((error){
      print( error );
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageF = image;
    });

    uploadPicture(context);
  }

  Future uploadPicture(BuildContext context) async {
    String filePath='images/${AuthService.userId.toString()}.png';
    final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://covidtrackerflutter.appspot.com');
    StorageUploadTask _uploadTask = _storage.ref().child(filePath).putFile(_imageF);
    StorageTaskSnapshot _taskSnapshot = await _uploadTask.onComplete;
    setState(() {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Picture uploaded"),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: getImage,
      child: Container(


          width: 150.0,
          height: 150.0,
          decoration: new BoxDecoration(

            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          //child: _imageF == null ? Icon(FontAwesomeIcons.plus) : Image.file(_imageF),
        child: imageFile == null ? Icon(FontAwesomeIcons.plus) : Image.memory(imageFile,fit: BoxFit.cover,),
      ),
      //Uploader(fileimage: _image),


    );
  }
}
