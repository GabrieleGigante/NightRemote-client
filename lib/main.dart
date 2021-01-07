import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class SocketService {
  IO.Socket socket;

  createSocketConnection() {
    socket = IO.io('http://192.168.1.4:7000', <String, dynamic>{
      'transports': ['websocket'],
    });
    print("aaaaaaaaa");
    this.socket.on("connect", (_) => print('Connected'));
    this.socket.on("disconnect", (_) => print('Disconnected'));
  }
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int val = 2;
    count = 0;
    delta = [0, 0];
    ss.createSocketConnection();
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Container(
        child: GestureDetector(
          onTap: () {
            ss.socket.emit('click');
            print("boop");
          },
          onPanUpdate: (details) {
            print(details.delta.dx.toString() +
                " " +
                details.delta.dy.toString());
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
        ),
      ),
    );
  }
}
