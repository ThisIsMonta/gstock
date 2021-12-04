import 'package:flutter/material.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/extra/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final members = [
    Member(name: "Ahmed ben ali", phoneNumber: "+216 50 104 523"),
    Member(name: "Ali ben salah", phoneNumber: "+216 99 441 001"),
    Member(name: "Montassar sghaier", phoneNumber: "+216 51 653 121"),
    Member(name: "Hamza jouini", phoneNumber: "+216 55 144 023"),
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
              hintText: 'Search for members',
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Flexible(
            child: /*ListView.builder(
            padding: EdgeInsets.all(10.0),
            shrinkWrap: true,
            itemCount: 40,
            itemBuilder: (BuildContext context, int index) {
              return CustomWidgets.memberCard(context, index);
            },
          ),*/
                Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: CustomWidgets.getWidth(context) * 0.0065,
            shrinkWrap: true,
            children: List.generate(members.length, (index) {
              return Dismissible(
                direction: DismissDirection.horizontal,
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: UniqueKey(),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    final bool res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to delete ${members[index].name} ?"),
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
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  setState(() {
                                    members.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 1),
                                      content: Text(
                                          'Member "${members[index].name}" removed !'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                    return res;
                  } 
                  else {
                    final bool callDialog = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "Are you sure you want to call ${members[index].name} ?"),
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
                                  "Call",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  UrlLauncher.launch("tel://21471576");
                                },
                              ),
                            ],
                          );
                        });
                    return callDialog;
                  }
                },
                background: CustomWidgets.slideLeftBackground(),
                secondaryBackground: CustomWidgets.callBackground(context),
                child: CustomWidgets.memberCard(members[index]),
              );
            }),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            height: 40.0,
            child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Add new member"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
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
                                hintText: 'Member name',
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
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
                                hintText: 'Member phone number',
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
                "Add new member",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
