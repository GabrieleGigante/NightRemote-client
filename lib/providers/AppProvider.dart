import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_manager/shared_preferences_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppProvider extends ChangeNotifier {
  SharedPreferencesManager spm = SharedPreferencesManager();
  IO.Socket socket;
  bool isConnected = false;
  static const volumeChannel = const MethodChannel('volume');

  String ip = '';
  int count = 0;
  int limit = 2; //put in place to make the cursor smoother with less cursor events firing
  List<double> delta = [0, 0];

  AppProvider() {
    // changeIP('192.168.1.12');
    init();
    setListenerVolume();
  }

  void init() async {
    if (ip.isEmpty) {
      ip = await spm.getKV('ip', '');
      if (ip.isEmpty) {
        log('need new ip');
        changeIP('192.168.1.12');
        return;
      }
    }
    connectToServer();
  }

  void changeIP(String newIP) async {
    ip = newIP;
    spm.setKV('ip', newIP);
    socket?.dispose();
    isConnected = false;
    notifyListeners();
    connectToServer();
  }

  void connectToServer() async {
    if (socket?.connected == true) {
      socket?.dispose();
      isConnected = false;
    }
    log(ip);

    try {
      socket = IO.io('http://$ip:7000', <String, dynamic>{
        'transports': ['websocket'],
      });
      socket.onConnect((data) {
        isConnected = true;
        log('socket connected');
        notifyListeners();
      });
    } on Exception catch (e) {
      log('ERROR: ' + e.toString());
    }
  }

  //events
  void onClick() async {
    socket?.emit('click');
  }

  void onMove(DragUpdateDetails details) async {
    double totMov = details.delta.dx.abs() + details.delta.dy.abs();
    //filtering junk values produced by resting your finger on the screen
    if (totMov < 1) return;

    if (count < limit) {
      delta[0] += details.delta.dx;
      delta[1] += details.delta.dy;
      count++;
    }

    if (count == limit) {
      socket?.emit('cursor', [details.delta.dx, details.delta.dy]);
      delta = [0, 0];
      count = 0;
    }
  }

  void setListenerVolume() async {
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
        socket.emit("volume", call.arguments);
        print(call.arguments);
    }
  }
}
