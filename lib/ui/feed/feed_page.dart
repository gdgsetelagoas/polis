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
      body: Stack(
        children: <Widget>[
          BlocBuilder(
            bloc: _bloc,
            builder: (_, state) {
              if (state is FeedList)
                return RefreshIndicator(
                  onRefresh: () async {
                    _bloc.dispatch(FeedRefresh(widget.feedContext));
                  },
                  child: ListView.builder(
                      itemCount: state.publications.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) => FeedItemTile(
                            publication: state.publications[index],
                            bloc: FeedTileBloc(
                                accountDataSource: _bloc.accountDataSource,
                                publicationDataSource:
                                    _bloc.publicationDataSource),
                            user: state.currentUser,
                          )),
                );
              return Center();
            },
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: StreamBuilder<bool>(
                stream: _bloc.outProcessing,
                initialData: false,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.data)
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator()),
                    );
                  return Container();
                }),
          )
        ],
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
