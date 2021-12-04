import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/classes/Member.dart';

class CustomWidgets {
  static Widget componentCard(BuildContext context, int index) {
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
            Container(
              child: Text("10/11/2021"),
            ),
          ],
        ),
      ),
    );
  }

  static Widget memberCard(Member member) {
    return Container(
      height: 32.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(color: Colors.grey, fontSize: 24.0),
                    ),
                    Text(
                      member.phoneNumber,
                      style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget categoryCard(Category category, int howManyComponents) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(
              category.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$howManyComponents components",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 24.0,
                  ),
                ),
                Icon(Icons.developer_board,color: Colors.grey[400],)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
