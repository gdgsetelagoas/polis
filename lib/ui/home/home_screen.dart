import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:res_publica/main.dart';
import 'package:res_publica/ui/feed/bloc/bloc.dart';
import 'package:res_publica/ui/feed/feed_page.dart';
import 'package:res_publica/ui/links/links_page.dart';
import 'package:res_publica/ui/obs/obs_page.dart';
import 'package:res_publica/ui/profile/bloc/profile_bloc.dart';
import 'package:res_publica/ui/profile/profile_page.dart';
import 'package:res_publica/ui/publication/bloc/publication_bloc.dart';
import 'package:res_publica/ui/publication/create_publication_screen.dart';
import 'package:res_publica/ui/settings/bloc/settings_bloc.dart';
import 'package:res_publica/ui/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titles = ["Feed", "Posts que sigo", "Links", "OBS", "Perfil"];
  List<List<Widget>> _actions;
  int _actualPage = 0;
  var _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _titles[_actualPage] == "Perfil"
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => BlocProvider(
                          builder: (_) =>
                              injector.get<PublicationBloc>("PublicationBloc"),
                          child: CreatePublicationScreen(),
                        )));
              },
              child: Icon(
                Icons.note_add,
              ),
            ),
      appBar: AppBar(
        title: Text(_titles[_actualPage]),
        centerTitle: true,
        actions: _actions[_actualPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black,
        currentIndex: _actualPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text(_titles[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            title: Text(_titles[1]),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.link),
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
              duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          _actualPage = page;
          setState(() {});
        },
        children: <Widget>[
          FeedPage(feedContext: FeedContext.GENERAL),
          FeedPage(feedContext: FeedContext.FOLLOWED),
          LinksPage(),
          OBSPage(),
          BlocProvider(
            builder: (_) => injector.get<ProfileBloc>("ProfileBloc"),
            child: ProfilePage(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _actions = [
      <Widget>[],
      <Widget>[],
      <Widget>[],
      <Widget>[],
      <Widget>[
        IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (c) => BlocProvider(
                      builder: (_) =>
                          injector.get<SettingsBloc>("SettingsBloc"),
                      child: SettingsScreen(),
                    )));
          },
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          tooltip: "Configurações",
        )
      ]
    ];
    super.initState();
  }
}
