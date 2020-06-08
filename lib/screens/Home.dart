import 'dart:async';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:covidtracker/services/AuthService.dart';
import 'package:covidtracker/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'AvatarePage.dart';
import 'package:covidtracker/components/contact_card.dart';
import 'package:covidtracker/components/constants.dart';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:nearby_connections/nearby_connections.dart';
import 'Login.dart';


class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //static Location location = new Location();

  static double latitude = 33.5911214;
  static double longitude  = -7.6089899;

  static GoogleMapController mapController;

  //static LatLng _center = LatLng(latitude, longitude);

  static void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  static Location location = Location();
  static Firestore _firestore = Firestore.instance;
  static final Strategy strategy = Strategy.P2P_STAR;
  static FirebaseUser loggedInUser;
  static String testText = '';
  static final _auth = FirebaseAuth.instance;
  static List<dynamic> contactTraces = [];
  static String currUsername='';

  static String emailUser = '';

  Future _getCurrentLocatin() async {
    final position = await geo.Geolocator().getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    print("New position");
    print(position);
    setState(() {
      latitude=position.latitude;
      longitude=position.longitude;
    });
    print(latitude);
    print(longitude);
    setState((){});
  }

  /*@override
  void createState() {
    _getCurrentLocatin();
    print("create State");
  }

  @override
  void initState() {
    _getCurrentLocatin();
    super.initState();
    print("init State");
  }*/



  /*****************************************************************************/


  void addContactsToList() async {
    await getCurrentUser();
    _firestore
        .collection('users')
        .document(AuthService.userId.toString())
        .snapshots()
        .listen((snapshot) {
      setState(() {
        currUsername = snapshot.data['fullname'];
      });

      if (!contactTraces.contains(currUsername)) {
        contactTraces.add(currUsername);
      }
      setState(() {
      });
      print("currentUserName:");
      print(currUsername);
    });
  }


  static void discovery() async {
  print("lets discovery");
    try {
      bool a = await Nearby().startDiscovery(
        currUsername,
        strategy,
        onEndpointFound: (String id,String userName, String serviceId) {
          contactTraces.add(userName);
          print("UserName:");
          print(userName);
        },
        onEndpointLost: (String id) {
          //called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: "flutter.jebjiayoub.covidtracker", // uniquely identifies your app
      );
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }
  }

  void getPermissions() {
    Nearby().askLocationAndExternalStoragePermission();
  }

  static Future<String> getUsernameOfEmail({String email}) async {
    String res = '';
    await _firestore.collection('users').document(AuthService.userId.toString()).get().then((doc) {
      if (doc.exists) {
        res = doc.data['fullname'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    addContactsToList();
    _getCurrentLocatin();
    getPermissions();

  }


/*******************************************************************************/


  static Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('home'),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Current Location'))
    ].toSet();
  }

  static Set<Circle> _circles = Set.from([
    Circle(
        circleId: CircleId('Infection'),
        center: LatLng(latitude, longitude),
        radius: 120,
        strokeColor: Colors.green[100],
        fillColor: Colors.green[100])
  ]);

  int _currentIndex = 0;

  final tabs = [
    SingleChildScrollView(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').document(AuthService.userId.toString()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data .. Please Wait ..');
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                ),
                Avatar(),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                ),
                Text("Full Name : "+snapshot.data['fullname'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Text("Phone Number : "+snapshot.data['phonenum'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Text("Age : "+snapshot.data['age'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Text("Ville : "+snapshot.data['ville'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              ],
            ),
          );
        },
      ),
    ),
    GoogleMap(
      markers: _createMarker(),
      circles: _circles,
      onMapCreated: _onMapCreated,
      //initialCameraPosition: CameraPosition(target: _center, zoom: 16.0),
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude,longitude),
        zoom: 16,
      )

    ),
    Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              bottom: 10.0,
              top: 30.0,
            ),
            child: Container(
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepPurple[500],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset:
                    Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Image(
                      image: AssetImage('assets/images/corona.png'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Your Contact Traces',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 5.0,
            color: Colors.deepPurple[400],
            onPressed: () async {
              try {
                bool a = await Nearby().startAdvertising(
                  currUsername,
                  strategy,
                  onConnectionInitiated: null,
                  onConnectionResult: (id, status) {
                    print(status);
                  },
                  onDisconnected: (id) {
                    print('Disconnected $id');
                  },
                );

                print('ADVERTISING ${a.toString()}');
              } catch (e) {
                print(e);
              }
              print("Discovery");
              discovery();
            },
            child: Text(
              'Start Tracing',
              style: kButtonTextStyle,

            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ContactCard(
                  imagePath: 'assets/images/profile1.jpg',
                  email: contactTraces[index],
                  infection: 'Not-Infected',
                  contactUsername: contactTraces[index],
                );
              },
              itemCount: contactTraces.length,
            ),
          ),
        ),

      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Map COVID-19 Tracker"),
        ),
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Map')),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes), title: Text('Traces')),
          ],
          onTap: (index) {
            _getCurrentLocatin();
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }


}
