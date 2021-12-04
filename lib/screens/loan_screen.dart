import 'package:flutter/material.dart';
import 'package:gstock/classes/Component.dart';
import 'package:gstock/classes/Loan.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/extra/custom_widgets.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final loans = [
    Loan(
        member: Member(name: "Ali", phoneNumber: "+216 21 471 576"),
        component:
            Component(name: "Item 1", quantity: 1, family: "Arduino Uno R2"),
        loanDate: DateTime(1, 1, 1990),
        status: "Still",
        state: ""),
    Loan(
        member: Member(name: "Ali", phoneNumber: "+216 21 471 576"),
        component:
            Component(name: "Item 2", quantity: 10, family: "Arduino Uno R2"),
        loanDate: DateTime(1, 1, 1990),
        status: "Returned",
        state: "Damaged"),
    Loan(
        member: Member(name: "Ali", phoneNumber: "+216 21 471 576"),
        component:
            Component(name: "Item 3", quantity: 2, family: "Arduino Uno R2"),
        loanDate: DateTime(1, 1, 1990),
        status: "Returned",
        state: "Intact"),
    Loan(
        member: Member(name: "Ali", phoneNumber: "+216 21 471 576"),
        component:
            Component(name: "Item 4", quantity: 4, family: "Arduino Uno R2"),
        loanDate: DateTime(1, 1, 1990),
        status: "Returned",
        state: "Damaged"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.0,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.grey[300],
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Search for loans',
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              shrinkWrap: true,
              itemCount: loans.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomWidgets.loanCard(loans[index]);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Add new loan"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Colors.green,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Colors.green[800],
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Add new loan",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: SizedBox(
                  height: 40.0,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Add new loan"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.category,
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 0.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Component',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      labelStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) =>
                            Theme.of(context).colorScheme.primary,
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primaryVariant,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "Generate loans",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
