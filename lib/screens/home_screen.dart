import 'package:flutter/material.dart';
import 'package:gstock/classes/Admin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required Admin user}) : super();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    // set initial pages for navigation to home page
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_handleTabSelection);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _tapNav(0);
                },
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.home,
                        color: _currentIndex == 0
                            ? Theme.of(context).colorScheme.primaryVariant
                            : Theme.of(context).colorScheme.surface))),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _tapNav(1);
                },
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.category,
                        color: _currentIndex == 1
                            ? Theme.of(context).colorScheme.primaryVariant
                            : Theme.of(context).colorScheme.surface))),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _tapNav(2);
                },
                child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(left: 32),
                    child: Icon(Icons.request_page,
                        color: _currentIndex == 2
                            ? Theme.of(context).colorScheme.primaryVariant
                            : Theme.of(context).colorScheme.surface))),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _tapNav(3);
                },
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.list_alt,
                        color: _currentIndex == 3
                            ? Theme.of(context).colorScheme.primaryVariant
                            : Theme.of(context).colorScheme.surface))),
          ],
        ),
        //shape: CircularNotchedRectangle(),
      ),
    );
  }

  void _tapNav(index) {
    _currentIndex = index;
    _pageController.jumpToPage(index);

    // this unfocus is to prevent show keyboard in the text field
    FocusScope.of(context).unfocus();
  }
}
