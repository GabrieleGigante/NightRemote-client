import 'package:flutter/material.dart';
import 'package:nightremote/providers/AppProvider.dart';
import 'package:provider/src/provider.dart';

class ChangeIPPopup extends StatelessWidget {
  ChangeIPPopup({Key key}) : super(key: key);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider app = context.watch<AppProvider>();
    if (controller.text.isEmpty) {
      controller = TextEditingController(text: app.ip);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
          color: Colors.blueGrey[900],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Current IP',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99999),
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton(
                child: Text('CONFIRM'),
                onPressed: () {
                  app.changeIP(controller.text);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
