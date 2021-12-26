import 'package:flutter/material.dart';
import 'package:gstock/classes/Admin.dart';
import 'package:gstock/extra/widgets_exporter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Admin user}) : super();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedPage = 0;
  final pages = [
    MembersScreen(),
    CategoriesScreen(),
    ComponentsScreen(),
    LoanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "Members",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airplay_rounded),
              label: "Components",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: "Loans",
            ),
          ],
        ),
      ),
    );
  }
}
