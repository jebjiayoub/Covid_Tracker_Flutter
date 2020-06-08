import 'dart:io';

import 'package:covidtracker/services/AuthService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {

  final File fileimage;
  Uploader({this.fileimage});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://covidtrackerflutter.appspot.com');
  StorageUploadTask _uploadTask;
  void _startUpload(){
    String filePath='images/${AuthService.userId.toString()}.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.fileimage);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_uploadTask != null){
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot){
          var event = snapshot?.data?.snapshot;
          double progressPercent = event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return null;
        },
      );
    }
    else{
      return FlatButton.icon(onPressed: _startUpload, icon: Icon(Icons.cloud_upload), label: Text('Upload to Firebase'));
    }
  }
}
