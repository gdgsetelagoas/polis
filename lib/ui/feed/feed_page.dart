import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:res_publica/main.dart';
import 'package:res_publica/ui/feed/bloc/bloc.dart';
import 'package:res_publica/ui/feed/widgets/feed_item_tile.dart';

class FeedPage extends StatefulWidget {
  final FeedContext feedContext;

  const FeedPage({Key key, @required this.feedContext}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FeedBloc _bloc = injector.get<FeedBloc>("FeedBloc");
  ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 100.0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc.dispatch(FeedLoadFeed(widget.feedContext));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: BlocBuilder(
        bloc: _bloc,
        builder: (c, s) {
          if (s is FeedList)
            return RefreshIndicator(
              onRefresh: () async {
                _bloc.dispatch(FeedRefresh(widget.feedContext));
              },
              child: ListView.builder(
                  itemCount: s.publications.length,
                  controller: _scrollController,
                  itemBuilder: (context, index) => FeedItemTile(
                        publication: s.publications[index],
                        bloc: _bloc,
                      )),
            );
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.dispatch(FeedLoadMore(widget.feedContext));
    }
  }
}
