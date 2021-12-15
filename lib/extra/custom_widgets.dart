import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/classes/Member.dart';

import 'package:intl/intl.dart';

class CustomWidgets {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget componentCard(dynamic component) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    component["name"],
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    component["categoryName"],
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Text(
              "Quantity : ${component["quantity"]}",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  static Widget loanCard(dynamic loan) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loan["memberName"],
                  style: TextStyle(color: Colors.grey, fontSize: 24.0),
                ),
                Text(
                  loan["phoneNumber1"],
                  style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  loan["componentName"],
                  style: TextStyle(color: Colors.grey[700], fontSize: 16.0),
                ),
                loan["returnDate"] != DateTime(1970).toIso8601String()
                    ? Text(
                        DateFormat("dd-MM-yyyy")
                            .format(DateTime.parse(loan["returnDate"])),
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      )
                    : SizedBox(
                        height: 20.0,
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quantity : ${loan["quantity"]}",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Status : ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                    children: [
                      TextSpan(
                        text: '${loan["status"]}',
                        style: TextStyle(
                          color: loan["status"] == "Non-returned"
                              ? Colors.green
                              : Colors.blue,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          loan["state"].toString().isNotEmpty
              ? Container(
            width: double.infinity,
                  color: loan["state"] == "Intact"
                      ? Colors.green
                      : Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${loan["state"]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
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
                      member.phoneNumber1,
                      style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                    ),
                    Text(
                      member.phoneNumber2.length > 0
                          ? member.phoneNumber2
                          : "No 2nd phone number",
                      style: TextStyle(
                          color: member.phoneNumber2.length > 0
                              ? Colors.grey[400]
                              : Colors.red[300],
                          fontSize: 16.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget categoryCard(
      BuildContext context, Category category, int howManyComponents) {
    return Card(
      child: Container(
        width: double.infinity,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  static Widget slideRightBackground(Icon icon, Color bgColor, String task) {
    return Container(
      color: bgColor,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            icon,
            Text(
              " $task",
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
