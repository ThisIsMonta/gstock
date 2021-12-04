import 'package:flutter/material.dart';
import 'package:gstock/classes/Member.dart';
import 'package:gstock/extra/custom_widgets.dart';

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
              childAspectRatio: 3.5,
              shrinkWrap: true,
              children: List.generate(members.length,(index){
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: UniqueKey(),
                  // Provide a function that tells the app
                  // what to do after an item has been swiped away.
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {
                      members.removeAt(index);
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Member "${members[index].name}" removed !')));
                  },
                  child: CustomWidgets.memberCard(members[index]),
                );
              }),
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            height: 40.0,
            child: TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) =>
                  Theme.of(context).colorScheme.primary,
                ),
                overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryVariant,),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),),
              ),
              child: Text("Add new member",style: TextStyle(color: Theme.of(context).colorScheme.onBackground),),
            ),
          ),
        ),
      ],
    );
  }
}
