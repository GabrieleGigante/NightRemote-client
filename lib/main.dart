import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightremote/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightremote/SocketManager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SocketService ss = SocketService();
  int count;
  List<double> delta;
  StreamSubscription vbe;
  SharedPreferences prefs;
  String ip;
  String validIp;
  bool isConnected;
  @override
  void initState() {
    isConnected = false;
    initSP();
    listenToVolume();
    super.initState();
  }

  int val = 2;

  @override
  Widget build(BuildContext context) {
    count = 0;
    delta = [0, 0];

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          ss.socket.emit('click');
          print("boop");
        },
        onPanUpdate: (details) {
          /*print(
              details.delta.dx.toString() + " " + details.delta.dy.toString());
          */
          if (this.count < val) {
            delta[0] += details.delta.dx;
            delta[1] += details.delta.dy;
            count++;
          }
          if (count == val) {
            ss.socket.emit('cursor', [delta[0], delta[1]]);
            delta[0] = 0;
            delta[1] = 0;
            count = 0;
          }
        },
        child: Container(
          color: Colors.blueGrey[900],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 40, //MediaQuery.of(context).size.height - 80,
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Popup(ss, (_ip) {
                            //print(_ip);
                            //ss.socket.close();
                            //ss.socket.dispose();
                            setState(() {
                              isConnected = false;
                              ip = _ip;
                            });
                            initSP();
                          });
                        });
                  },
                  child: Text(
                    "Remote",
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ),
              isConnected
                  ? Text(
                      "+",
                      style: TextStyle(
                          color: Colors.white,
                          //fontFamily: 'Roboto Mono',
                          fontSize: 72,
                          fontWeight: FontWeight.w200),
                    )
                  : Text(
                      "Connecting...",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void initSP() async {
    //print("initSP called");
    prefs = await SharedPreferences.getInstance();
    ip = prefs.getString("ip");
    ss.createSocketConnection(ip, (isconnected) {
      print("isconnected: " + isconnected.toString());
      if (isconnected) {
        setState(() {
          isConnected = true;
        });
      } else {
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    vbe?.cancel();
    super.dispose();
  }

  static const volumeChannel = const MethodChannel('volume');

  void listenToVolume() async {
    try {
      volumeChannel.setMethodCallHandler(
          (_didRecieveTranscript)); //volumeChannel.invokeMethod('getVolumeStatus');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _didRecieveTranscript(MethodCall call) async {
    switch (call.method) {
      case "volume":
        ss.socket.emit("volume", call.arguments);
        print(call.arguments);
    }
  }
}
