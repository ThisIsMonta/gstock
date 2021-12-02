import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  static Widget listItem(BuildContext context, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Item 1",
                    style: TextStyle(color: Colors.grey, fontSize: 24.0),
                  ),
                  Text(
                    "Family 1",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                TextButton(onPressed: () {}, child: Text("+")),
                Text("9"),
                TextButton(onPressed: () {}, child: Text("-"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
