import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/classes/Component.dart';
import 'package:gstock/classes/Member.dart';

class CustomWidgets {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget componentCard(Component component) {
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
                    component.name,
                    style: TextStyle(color: Colors.grey, fontSize: 24.0),
                  ),
                  Text(
                    component.family,
                    style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text("10/11/2021"),
                Text("Quantity : ${component.quantity}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget memberCard(Member member) {
    return Container(
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
            SizedBox(
              height: 10.0,
            ),
            Text(
              category.name,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 24.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
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
                Icon(
                  Icons.developer_board,
                  color: Colors.grey[400],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  static Widget callBackground(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.phone,
              color: Colors.white,
            ),
            Text(
              " Call",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  static Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
