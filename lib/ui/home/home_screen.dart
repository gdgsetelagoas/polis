import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titles = ["Feed", "Meus Posts", "Posts que sigo", "OBS", "Perfil"];
  int _actualPage = 0;
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.note_add),
      ),
      appBar: AppBar(
        title: Text(_titles[_actualPage]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColorDark,
        currentIndex: _actualPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text(_titles[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboard),
            title: Text(_titles[1]),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            title: Text(_titles[2]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(_titles[3]),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userAstronaut),
            title: Text(_titles[4]),
          ),
        ],
        onTap: (page) {
          _actualPage = page;
          setState(() {});
          _pageController.animateToPage(_actualPage,
              duration: Duration(milliseconds: 250),
              curve: Curves.bounceInOut);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          _actualPage = page;
          setState(() {});
        },
        children: <Widget>[
          Center(child: Text(_titles[0])),
          Center(child: Text(_titles[1])),
          Center(child: Text(_titles[2])),
          Center(child: Text(_titles[3])),
          Center(child: Text(_titles[4])),
        ],
      ),
    );
  }
}
