import 'package:flutter/material.dart';
import 'package:nightremote/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nightremote/SocketManager.dart';

class Popup extends StatefulWidget {
  SocketService socket;
  Popup(this.socket, this.callback);
  Function(String) callback;
  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  TextEditingController ip = TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initSP();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                TextField(
                    controller: ip,
                    decoration: InputDecoration(hintText: ip.text)),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width - 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.blue[900],
                  onPressed: () {
                    //print(ip.text);
                    prefs.setString('ip', ip.text.trim());
                    widget.callback(ip.text.trim());
                    Navigator.pop(context);
                  },
                  child: Text(
                    "UPDATE IP",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void initSP() async {
    prefs = await SharedPreferences.getInstance();
    ip.text = prefs.getString("ip");
  }
}
