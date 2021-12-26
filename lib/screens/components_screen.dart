import 'package:flutter/material.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/classes/Component.dart';
import 'package:gstock/database/database_helper.dart';
import 'package:gstock/extra/custom_widgets.dart';

class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({Key? key}) : super(key: key);

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {

  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  bool isLoading = false;
  final _addComponentFormKey = GlobalKey<FormState>();

  late List<dynamic> components;
  late List<Category> categories;

  dynamic selectedCategory;
  late List<DropdownMenuItem> menuItemList;
  bool isCategoriesNull = false;

  int _selectedQuantityToUpdate = 0;

  @override
  void initState() {
    super.initState();
    getAllComponents();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.closeDB();
    super.dispose();
  }

  Future getAllComponents() async {
    setState(() {
      isLoading = true;
    });
    this.components = await DatabaseHelper.instance.getAllComponents();
    this.categories = await DatabaseHelper.instance.getAllCategories();
    if(categories.isEmpty){
      setState(() {
        isLoading = false;
        isCategoriesNull = true;
      });
      return;
    }else{
      selectedCategory = categories[0];
      menuItemList = categories
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

  Future<Component> addComponent(Component component) async {
    return await DatabaseHelper.instance.addComponent(component);
  }

  Future<int> updateComponent(int id) async {
    return await DatabaseHelper.instance.updateQuantity(_selectedQuantityToUpdate,id);
  }

  Future<int> deleteComponent(int id) async {
    return await DatabaseHelper.instance.deleteComponent(id);
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
            onChanged: (value) {
              searchForComponent(value);
            },
            controller: _searchController,
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
              hintText: 'Search for components',
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  getAllComponents();
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
            child : isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : this.categories.isNotEmpty && this.components.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: components.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                            "Are you sure you want to delete ${components[index]["name"]} ?"),
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
                                              int res = await deleteComponent(components[index]["id"]!);
                                            if (res == 1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  content: Text(
                                                      'Component "${components[index]["name"]}" removed !'),
                                                ),
                                              );
                                              getAllComponents();
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
                                setState(() {
                                  _selectedQuantityToUpdate = components[index]["quantity"];
                                });
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context,setState){
                                          return AlertDialog(
                                            title: Text(
                                                "Update ${components[index]["name"]}'s quantity"),
                                            content: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _selectedQuantityToUpdate++;
                                                    });
                                                    print(_selectedQuantityToUpdate);
                                                  },
                                                  icon: Icon(Icons.add),
                                                ),
                                                Text("$_selectedQuantityToUpdate"),
                                                IconButton(
                                                  onPressed: () {
                                                    if(_selectedQuantityToUpdate>=1){
                                                      setState(() {
                                                        _selectedQuantityToUpdate--;
                                                      });
                                                      print(_selectedQuantityToUpdate);
                                                    }
                                                  },
                                                  icon: Icon(Icons.remove),
                                                ),
                                              ],
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
                                                  style:
                                                  TextStyle(color: Colors.red),
                                                ),
                                                onPressed: () async {
                                                  int res = await updateComponent(components[index]["id"]);
                                                  if (res == 1) {
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        duration: const Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                            'Component "${components[index]["name"]}" updated !'),
                                                      ),
                                                    );
                                                    getAllComponents();
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
                                        }
                                      );
                                    });
                                return res;
                              }
                            },
                            background: CustomWidgets.slideLeftBackground(),
                            secondaryBackground:
                              CustomWidgets.slideRightBackground(Icon(Icons.edit,color: Colors.white,),(Colors.blue[700])!,"Edit"),
                            child: CustomWidgets.componentCard(
                                components[index]),
                          );
                        },
                      )
                    : Center(
                        child: Text("No components found, add new ones"),
                      ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            height: 40.0,
            child: TextButton(
              onPressed: isCategoriesNull ? null : () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Add new component"),
                        content: Form(
                          key: _addComponentFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.settings_input_component,
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
                                  hintText: 'Component name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelStyle: TextStyle(color: Colors.grey),
                                ),
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
                                  hintText: 'Component quantity',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  labelStyle: TextStyle(color: Colors.grey),
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
                                child: DropdownButtonFormField<dynamic>(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.category),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    value: selectedCategory,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.grey),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCategory = newValue;
                                      });
                                    },
                                    items: this.menuItemList),
                              ),
                              SizedBox(
                                height: 10.0,
                              )
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
                              if (_addComponentFormKey.currentState!
                                  .validate()) {
                                Component res = await addComponent(
                                  Component(
                                      name: _nameController.text,
                                      quantity:
                                          int.parse(_quantityController.text),
                                      categoryId: selectedCategory.id),
                                );
                                print("res $res");
                                if (res != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Category added')),
                                  );
                                  _addComponentFormKey.currentState!.reset();
                                  Navigator.of(context).pop();
                                  getAllComponents();
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
                  isCategoriesNull ? Colors.red: Theme.of(context).colorScheme.primary,
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
                isCategoriesNull ? "Add categories first..." : "Add new component",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void searchForComponent(String name) async {
    if (name.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      this.components = await DatabaseHelper.instance.searchComponents(name);
      setState(() {
        isLoading = false;
      });
    } else {
      this.components = await DatabaseHelper.instance.getAllComponents();
    }
  }

}
