import 'package:flutter/material.dart';
import 'package:nightremote/pages/ChangeIPPopup.dart';
import 'package:nightremote/providers/AppProvider.dart';
import 'package:provider/src/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider app = context.watch<AppProvider>();
    return Scaffold(
      body: GestureDetector(
        onTap: () => app.onClick(),
        onPanUpdate: (details) => app.onMove(details),
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
                  onTap: () => showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (ctx) => ChangeIPPopup(),
                  ),
                  child: Text(
                    "Remote",
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ),
              app.isConnected
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
}
