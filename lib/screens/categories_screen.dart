import 'package:flutter/material.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/extra/custom_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final categories = [
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
    Category(name: "Arduino Uno R2"),
    Category(name: "STM32F407"),
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
              hintText: 'Search for category',
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: CustomWidgets.getWidth(context)*0.005,
              shrinkWrap: true,
              children: List.generate(categories.length, (index) {
                return CustomWidgets.categoryCard(categories[index], index);
              }),
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
                        title: Text("Add new category"),
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
                                hintText: 'Category name',
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
                overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryVariant,),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),),
              ),
              child: Text("Add new category",style: TextStyle(color: Theme.of(context).colorScheme.onBackground),),
            ),
          ),
        ),
      ],
    );
  }
}
