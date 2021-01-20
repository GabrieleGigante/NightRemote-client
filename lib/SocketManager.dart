import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket;

  createSocketConnection(String ip, Function(bool) callback) {
    socket = IO.io('http://$ip:7000', <String, dynamic>{
      'transports': ['websocket'],
    });
    //print(socket.connected);
    if (socket.connected)
      callback(true);
    else
      callback(false);
    this.socket.on("connect", (_) => callback(true));
    this.socket.on("disconnect", (_) => callback(false));
  }

  close() {
    socket..disconnect();
  }
}
