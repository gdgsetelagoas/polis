import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/bloc.dart';
import 'package:res_publica/ui/feed/widgets/feed_item_tile.dart';
import 'package:res_publica/ui/reply/widgets/reply_widget.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class ViewPublicationScreen extends StatefulWidget {
  final PublicationEntity publication;
  final int sourceIndex;
  final VideoPlayerController videoPlayerController;
  final FeedTileBloc bloc;
  final bool reply;
  final UserEntity user;

  const ViewPublicationScreen({
    Key key,
    @required this.publication,
    this.sourceIndex,
    this.videoPlayerController,
    @required this.bloc,
    this.reply = false,
    this.user,
  })  : assert(publication != null),
        super(key: key);

  @override
  _ViewPublicationScreenState createState() => _ViewPublicationScreenState();
}

class _ViewPublicationScreenState extends State<ViewPublicationScreen> {
  UserEntity _user;
  TextEditingController _replyController = TextEditingController();
  FocusNode _replyFocus = FocusNode();
  GlobalKey _bottomFieldReply = GlobalKey();
  FeedRepliesLoaded _repliesState;

  @override
  void initState() {
    widget.bloc.dispatch(FeedLoadReplies(
        publication: widget.publication, itemsPerPage: 25, page: 0));
    widget.bloc.dispatch(FeedLoadUserData(userId: widget.publication.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 4.0,
            ),
            child: BlocBuilder(
                bloc: widget.bloc,
                condition: (oldState, newState) {
                  if (newState is FeedUserDataLoaded) {
                    _user = newState.user;
                    return true;
                  }
                  return false;
                },
                builder: (context, state) => AppCircularImage(
                      _user?.photo ?? "",
                      size: 48.0,
                      fit: BoxFit.cover,
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    )),
          ),
        ),
        title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder(
                bloc: widget.bloc,
                condition: (oldState, newState) {
                  if (newState is FeedUserDataLoaded) {
                    _user = newState.user;
                    return true;
                  }
                  return false;
                },
                builder: (context, state) => Text(
                  _user?.name ?? "🔌 Carregando..",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "  ${timeago.format(widget.publication.createdAt, locale: "pt_BR")}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              )
            ]),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (c) {
              if (widget.user != null &&
                  widget.user.userId == widget.publication.userId)
                return [
                  PopupMenuItem<String>(
                    child: Text("Denunciar..."),
                    value: "denunciar",
                  ),
                  PopupMenuItem<String>(
                    child: Text("Editar"),
                    value: "editar",
                  ),
                  PopupMenuItem<String>(
                    child: Text("Excluir"),
                    value: "excluir",
                  ),
                ];
              return [
                PopupMenuItem<String>(
                  child: Text("Denunciar..."),
                  value: "denunciar",
                )
              ];
            },
            tooltip: "Mais OpçformattedStringões",
            onSelected: (item) {
              widget.bloc.dispatch(FeedButtonMenuItemPressed(option: item));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white70,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  bottom: (_bottomFieldReply.currentContext?.findRenderObject()
                              as RenderBox)
                          ?.size
                          ?.height ??
                      75.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: FeedItemTile(
                      bloc: widget.bloc,
                      publication: widget.publication,
                      user: widget.user,
                      bodyExpanded: true,
                      hideHeader: true,
                    ),
                  ),
                  BlocBuilder(
                    bloc: widget.bloc,
                    condition: (oldState, newState) {
                      if (newState is FeedRepliesLoaded) {
                        _repliesState = newState;
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (_repliesState == null)
                        return SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            ReplyWidget.shimmer(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.00)),
                            ReplyWidget.shimmer(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.00)),
                            ReplyWidget.shimmer(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.00)),
                            ReplyWidget.shimmer(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.00)),
                            ReplyWidget.shimmer(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.00))
                          ]),
                        );
                      if (_repliesState.replies.isNotEmpty)
                        return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return ReplyWidget(
                              reply: _repliesState.replies[index],
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.00),
                            );
                          }, childCount: _repliesState.replies.length),
                        );
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 350,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.add_comment,
                                    size: 64.0,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(180),
                                  ),
                                  Text(
                                      "Essa publicação ainda não tem nenhum comentario.\nSeja o primeiro a comentar",
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                key: _bottomFieldReply,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _replyController,
                        focusNode: _replyFocus,
                        autofocus: widget.reply,
                        autocorrect: true,
                        minLines: 1,
                        maxLines: 8,
                        scrollPhysics: BouncingScrollPhysics(),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300))),
                      ),
                    )),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          if (_replyController.text.isEmpty) return;
                          widget.bloc.dispatch(
                              FeedButtonRepliesPublicationPressed(
                                  reply: ReplyEntity(
                                      body: _replyController.text,
                                      publicationId:
                                          widget.publication.publicationId,
                                      createdAt:
                                          DateTime.now().toIso8601String())));
                          _replyController.text = "";
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
