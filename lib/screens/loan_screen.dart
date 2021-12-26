import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gstock/classes/Loan.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/database/database_helper.dart';
import 'package:gstock/extra/custom_widgets.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen>
    with SingleTickerProviderStateMixin {
  final _addLoanFormKey = GlobalKey<FormState>();
  final _returnedComponentFormKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _quantityController = TextEditingController();
  late TabController _tabController;

  late List<dynamic> loans;
  late List<dynamic> components;
  late List<Member> members;
  bool isLoading = false;
  bool isComponentsNull = false;

  late dynamic selectedComponent;
  late dynamic selectedMember;
  late List<DropdownMenuItem> categoriesListMenu;
  late List<DropdownMenuItem> membersListMenu;

  List<Widget> tabs = [
    Tab(
      text: 'All',
    ),
    Tab(
      text: 'Non-returned',
    ),
    Tab(
      text: 'Returned',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      initialIndex: 0,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
    getAllLoans();
  }

  Future getAllLoans() async {
    setState(() {
      isLoading = true;
    });
    this.loans = await DatabaseHelper.instance.getAllLoans();
    this.components = await DatabaseHelper.instance.getAllComponents();
    this.members = await DatabaseHelper.instance.getAllMembers();
    if(components.isEmpty || members.isEmpty){
      setState(() {
        isLoading = false;
        isComponentsNull = true;
      });
      return;
    }else{
      selectedComponent = components[0];
      selectedMember = members[0];
      categoriesListMenu = components
          .map(
            (val) => DropdownMenuItem(
          value: val,
          child: Text(val["name"]),
        ),
      )
          .toList();
      membersListMenu = members
          .map(
            (val) => DropdownMenuItem(
          value: val,
          child: Text(val.name),
        ),
      )
          .toList();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Loan> addLoan(Loan loan) async {
    return await DatabaseHelper.instance.addLoan(loan,selectedComponent);
  }

  Future<int> markAsReturned(dynamic loan,String date,String state) async {
    return await DatabaseHelper.instance.markComponentAsReturned(loan,date,state);
  }

  Future<int> deleteLoan(dynamic loan) async {
    return await DatabaseHelper.instance.deleteLoan(loan);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          filterLoans(0);
          break;
        case 1:
          filterLoans(1);
          break;
        case 2:
          filterLoans(2);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16.0,
        ),
        Container(
          child: TabBar(
            tabs: tabs,
            controller: _tabController,
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            labelColor: Colors.white,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : this.loans.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        shrinkWrap: true,
                        itemCount: loans.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            direction: loans[index]["status"] != "Returned" ? DismissDirection.horizontal : DismissDirection.none,
                            key: UniqueKey(),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Are you sure you want to delete this loan ?"),
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
                                              int res = await deleteLoan(loans[index]!);
                                              if (res == 1) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                        'Loan removed !'),
                                                  ),
                                                );
                                                getAllLoans();
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
                                DateTime _returnedDate;
                                String statusInitialValue = "Intact";
                                final bool returnedDialog = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Add new component"),
                                        content: Form(
                                          key: _returnedComponentFormKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: _dateController,
                                                readOnly: true,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                onTap: () {
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2100),
                                                  ).then(
                                                      (value) => setState(() {
                                                            _returnedDate =
                                                                value!;
                                                            _dateController.text = value.toIso8601String();
                                                          }));
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'date is required !';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.date_range,
                                                    color: Colors.grey,
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.grey[300],
                                                  contentPadding:
                                                      new EdgeInsets.symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 0.0),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  hintText: 'Return date',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: DropdownButtonFormField<String>(
                                                  value: statusInitialValue,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.emoji_emotions_rounded),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.transparent),
                                                    ),
                                                  ),
                                                  style: const TextStyle(color: Colors.grey),
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      statusInitialValue = newValue!;
                                                    });
                                                  },
                                                  items: <String>['Intact', 'Damaged', 'Severely damaged']
                                                      .map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                              "Update",
                                              style: TextStyle(
                                                  color: Colors.blueAccent),
                                            ),
                                            onPressed: () async {
                                              if (_returnedComponentFormKey
                                                  .currentState!
                                                  .validate()) {
                                                print("id : ${loans[index]["id"]}, date : ${_dateController.text}, state : $statusInitialValue");
                                                int res =
                                                    await markAsReturned(loans[index],_dateController.text,statusInitialValue);
                                                print("res $res");
                                                if (res != 0) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Loan marked as returned')),
                                                  );
                                                  _returnedComponentFormKey
                                                      .currentState!
                                                      .reset();
                                                  Navigator.of(context).pop();
                                                  getAllLoans();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text('Error')),
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
                                return returnedDialog;
                              }
                            },
                            background: CustomWidgets.slideLeftBackground(),
                            secondaryBackground:
                                CustomWidgets.slideRightBackground(
                                    Icon(
                                      Icons.check_box,
                                      color: Colors.white,
                                    ),
                                    (Colors.blue[700])!,
                                    "Mark as returned"),
                            child: CustomWidgets.loanCard(loans[index]),
                          );
                        },
                      )
                    : Center(
                        child: Text("No Loans found, add new ones"),
                      ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            height: 40.0,
            child: TextButton(
              onPressed: isComponentsNull ? null : () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Add new loan"),
                        content: Form(
                          key: _addLoanFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonFormField<dynamic>(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.category),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    value: selectedComponent,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.grey),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedComponent = newValue;
                                      });
                                    },
                                    items: this.categoriesListMenu),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonFormField<dynamic>(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    value: selectedMember,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.grey),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedMember = newValue;
                                      });
                                    },
                                    items: this.membersListMenu),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.twenty_one_mp,
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
                                  hintText: 'Quantity',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'quantity is required !';
                                  }
                                  return null;
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
                          FlatButton(
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                            onPressed: () async {
                              if (_addLoanFormKey.currentState!.validate()) {
                                if(int.parse(_quantityController.text) > selectedComponent["quantity"]){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Quantity unavailable !')),
                                  );
                                }else{
                                  Loan res = await addLoan(Loan(
                                      memberId: selectedMember.id,
                                      componentId: selectedComponent["id"],
                                      quantity:
                                      int.parse(_quantityController.text),
                                      status: "Non-returned",
                                      state: '',
                                      returnDate: DateTime(1970)));
                                  print("res $res");
                                  if (res != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Loan added')),
                                    );
                                    _addLoanFormKey.currentState!.reset();
                                    Navigator.of(context).pop();
                                    getAllLoans();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error')),
                                    );
                                  }
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
                  (Set<MaterialState> states) => isComponentsNull ? Colors.red : Colors.green,
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
                isComponentsNull ? "Add members or components first..." : "Add new loan",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  filterLoans(int index) async {
    switch(index){
      case 0:
        setState(() {
          isLoading = true;
        });
        this.loans = await DatabaseHelper.instance.getAllLoans();
        setState(() {
          isLoading = false;
        });
        break;
      case 1:
        setState(() {
          isLoading = true;
        });
        this.loans = await DatabaseHelper.instance.getAllNonReturnedLoans();
        setState(() {
          isLoading = false;
        });
        break;
      case 2:
        setState(() {
          isLoading = true;
        });
        this.loans = await DatabaseHelper.instance.getAllReturnedLoans();
        setState(() {
          isLoading = false;
        });
        break;
      default:
        setState(() {
          isLoading = true;
        });
        this.loans = await DatabaseHelper.instance.getAllLoans();
        setState(() {
          isLoading = false;
        });
        break;
    }
  }
}
