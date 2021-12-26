import 'package:flutter/material.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/database/database_helper.dart';
import 'package:gstock/extra/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumber1Controller = TextEditingController();
  TextEditingController _phoneNumber2Controller = TextEditingController();
  bool isLoading = false;
  final _addMemberFormKey = GlobalKey<FormState>();

  late List<Member> members;

  @override
  void initState() {
    super.initState();
    getAllMembers();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.closeDB();
    super.dispose();
  }

  Future getAllMembers() async {
    setState(() {
      isLoading = true;
    });
    this.members = await DatabaseHelper.instance.getAllMembers();
    setState(() {
      isLoading = false;
    });
  }

  Future<Member> addMember(Member member) async {
    return await DatabaseHelper.instance.addMember(member);
  }

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
            controller: _searchController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            onChanged: (value) {
              filterSearchResults(value);
            },
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
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        getAllMembers();
                      },
                      icon: Icon(Icons.clear),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : this.members.isNotEmpty
                    ? GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio:
                            CustomWidgets.getWidth(context) * 0.005,
                        shrinkWrap: true,
                        children: List.generate(members.length, (index) {
                          return Dismissible(
                            direction: DismissDirection.horizontal,
                            key: UniqueKey(),
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
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              int res = await DatabaseHelper
                                                  .instance
                                                  .deleteMember(members[index]);
                                              if (res == 1) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                        'Member "${members[index].name}" removed !'),
                                                  ),
                                                );
                                                getAllMembers();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                        'Error has occurred !'),
                                                  ),
                                                );
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                return res;
                              } else {
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
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Call",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              UrlLauncher.launch(
                                                  "tel://${members[index].phoneNumber1}");
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                return callDialog;
                              }
                            },
                            background: CustomWidgets.slideLeftBackground(),
                            secondaryBackground:
                              CustomWidgets.slideRightBackground(Icon(Icons.call,color: Colors.white,),(Colors.blue[900])!,"Call"),
                            child: CustomWidgets.memberCard(members[index]),
                          );
                        }),
                      )
                    : Center(
                        child: Text("No Members found, add new ones"),
                      ),
          ),
        ),
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
                        content: Form(
                          key: _addMemberFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'name is required !';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _phoneNumber1Controller,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required !';
                                  }else if(value.length!=8){
                                    return 'Phone number must be 8 numbers !';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _phoneNumber2Controller,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[300],
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
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
                                  hintText: 'Member phone number 2 (optional)',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  return;
                                },
                              ),
                            ],
                          ),
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
                          ElevatedButton(
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_addMemberFormKey.currentState!.validate()) {
                                Member res = await addMember(
                                  Member(
                                    name: _nameController.text,
                                    phoneNumber1: _phoneNumber1Controller.text,
                                    phoneNumber2:
                                        _phoneNumber2Controller.text.length > 0
                                            ? _phoneNumber2Controller.text
                                            : "",
                                  ),
                                );
                                print("res $res");
                                if (res != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Member added')),
                                  );
                                  _addMemberFormKey.currentState!.reset();
                                  Navigator.of(context).pop();
                                  getAllMembers();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Error')),
                                  );
                                }
                              } else {
                                print("not valid");
                              }
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

  void filterSearchResults(String name) async {
    if (name.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      this.members = await DatabaseHelper.instance.searchMembers(name);
      setState(() {
        isLoading = false;
      });
    } else {
      this.members = await DatabaseHelper.instance.getAllMembers();
    }
  }
}
