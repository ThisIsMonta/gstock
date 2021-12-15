import 'package:flutter/material.dart';
import 'package:gstock/classes/Category.dart';
import 'package:gstock/database/database_helper.dart';
import 'package:gstock/extra/custom_widgets.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _updateNameController = TextEditingController();
  bool isLoading = false;
  final _addCategoryFormKey = GlobalKey<FormState>();
  final _updateCategoryFormKey = GlobalKey<FormState>();

  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.closeDB();
    super.dispose();
  }

  Future getAllCategories() async {
    setState(() {
      isLoading = true;
    });
    this.categories = await DatabaseHelper.instance.getAllCategories();
    setState(() {
      isLoading = false;
    });
  }

  Future<Category> addCategory(Category category) async {
    return await DatabaseHelper.instance.addCategory(category);
  }

  Future<int> updateCategory(int id, String name) async {
    return await DatabaseHelper.instance.updateCategory(id, name);
  }

  Future<int> deleteCategory(int id) async {
    return await DatabaseHelper.instance.deleteCategory(id);
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
              searchForCategory(value);
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
              hintText: 'Search for category',
              hintStyle: TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey),
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        getAllCategories();
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
                : this.categories.isNotEmpty
                    ? GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio:
                            CustomWidgets.getWidth(context) * 0.0075,
                        shrinkWrap: true,
                        children: List.generate(categories.length, (index) {
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
                                              "Are you sure you want to delete ${categories[index].name} ?"),
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
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () async {
                                                int res = await deleteCategory(
                                                    categories[index].id!);
                                                if (res == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      content: Text(
                                                          'Category "${categories[index].name}" removed !'),
                                                    ),
                                                  );
                                                  getAllCategories();
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
                                  final bool editDialog = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        _updateNameController.text =
                                            categories[index].name;
                                        return AlertDialog(
                                          title: Text(
                                              "Update ${categories[index].name}"),
                                          content: Form(
                                            key: _updateCategoryFormKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller:
                                                      _updateNameController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'name is required !';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.category,
                                                      color: Colors.grey,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.grey[300],
                                                    contentPadding:
                                                        new EdgeInsets
                                                                .symmetric(
                                                            vertical: 0.0,
                                                            horizontal: 0.0),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: 'Category name',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey),
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
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
                                                if (_updateCategoryFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  int res =
                                                      await updateCategory(
                                                          categories[index].id!,
                                                          _updateNameController
                                                              .text);
                                                  print("res $res");
                                                  if (res != 0) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Category updated')),
                                                    );
                                                    _updateCategoryFormKey
                                                        .currentState!
                                                        .reset();
                                                    Navigator.of(context).pop();
                                                    getAllCategories();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Error'),
                                                      ),
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
                                  return editDialog;
                                }
                              },
                              background: CustomWidgets.slideLeftBackground(),
                              secondaryBackground:
                                  CustomWidgets.slideRightBackground(Icon(Icons.edit,color: Colors.white,),Colors.green,"Edit"),
                              child: CustomWidgets.categoryCard(
                                  context, categories[index], index));
                        }),
                      )
                    : Center(
                        child: Text("No categories found, add new ones"),
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
                        content: Form(
                          key: _addCategoryFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'name is required !';
                                  }
                                  return null;
                                },
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
                              if (_addCategoryFormKey.currentState!
                                  .validate()) {
                                Category res = await addCategory(
                                  Category(
                                    name: _nameController.text,
                                  ),
                                );
                                print("res $res");
                                if (res != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Category added')),
                                  );
                                  _addCategoryFormKey.currentState!.reset();
                                  Navigator.of(context).pop();
                                  getAllCategories();
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
                "Add new category",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void searchForCategory(String name) async {
    if (name.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      this.categories = await DatabaseHelper.instance.searchCategories(name);
      setState(() {
        isLoading = false;
      });
    } else {
      this.categories = await DatabaseHelper.instance.getAllCategories();
    }
  }
}
