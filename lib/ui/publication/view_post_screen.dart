import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/bloc.dart';
import 'package:res_publica/ui/feed/widgets/feed_item_player.dart';
import 'package:res_publica/ui/feed/widgets/feed_react_select.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class ViewPublicationScreen extends StatefulWidget {
  final PublicationEntity publication;
  final int sourceIndex;
  final VideoPlayerController videoPlayerController;
  final FeedBloc bloc;
  final bool reply;

  const ViewPublicationScreen({
    Key key,
    @required this.publication,
    this.sourceIndex,
    this.videoPlayerController,
    @required this.bloc,
    this.reply = false,
  })  : assert(publication != null),
        super(key: key);

  @override
  _ViewPublicationScreenState createState() => _ViewPublicationScreenState();
}

class _ViewPublicationScreenState extends State<ViewPublicationScreen> {
  UserEntity _user;
  PageController _pageController;
  TextEditingController _replyController = TextEditingController();
  FocusNode _replyFocus = FocusNode();
  GlobalKey _reactButtonKey = GlobalKey();

  @override
  void initState() {
    widget.bloc.getUserData(widget.publication.userId).then((user) {
      _user = user ?? UserEntity(name: "Desconhecido");
      setState(() {});
    });
    _pageController = PageController(initialPage: widget.sourceIndex ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppCircularImage(
              _user?.photo ?? "",
              size: 48.0,
              fit: BoxFit.cover,
              borderSide:
                  BorderSide(color: Theme.of(context).accentColor, width: 2.5),
              shadows: [
                BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 0.5),
                    blurRadius: 2.5)
              ],
            ),
          ),
        ),
        title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _user?.name ?? "🔌 Carregando..",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "  ${timeago.format(widget.publication.createdAt, locale: "pt_BR")}",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              )
            ]),
      ),
      body: Container(
        color: Colors.white70,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: widget.publication.subtitle,
                onTapLink: (link) {
                  print(link);
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: widget.publication.resources.isEmpty
                  ? 0.0
                  : MediaQuery.of(context).size.width,
              child: PageView.builder(
                  itemCount: widget.publication.resources.length,
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    var res = widget.publication.resources[index];
                    if (res.type == PublicationResourceType.IMAGE)
                      return Container(
                        color: Colors.grey.shade300,
                        child: Image.network(
                          res.source,
                          fit: BoxFit.cover,
                        ),
                      );
                    return FeedItemPlayer(url: res.source);
                  }),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  key: _reactButtonKey,
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${widget.publication.numReacts} Reaç${widget.publication.numReacts > 1 ? "ôes" : "ão"}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onLongPress: () async {
                      var react = await showDialog<ReactEntity>(
                          context: context,
                          barrierDismissible: false,
                          builder: (con) {
                            RenderBox renderReactButton = _reactButtonKey
                                .currentContext
                                .findRenderObject();
                            return FeedReactSelect(
                                offset: renderReactButton
                                    .localToGlobal(Offset.zero));
                          });
                      if (react != null)
                        widget.bloc.dispatch(FeedButtonReactPublicationPressed(
                            react: react
                              ..publicationId = widget.publication.publicationId
                              ..createdAt = DateTime.now().toIso8601String()));
                    },
                    onTap: () {
                      widget.bloc.dispatch(FeedButtonReactPublicationPressed(
                          react: ReactEntity(
                              publicationId: widget.publication.publicationId,
                              type: ReactType.LIKE,
                              createdAt: DateTime.now().toIso8601String())));
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${widget.publication.numReplies} Comentário${widget.publication.numReplies > 1 ? "s" : ""}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => ViewPublicationScreen(
                                publication: widget.publication,
                                reply: true,
                                bloc: widget.bloc,
                              )));
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${widget.publication.numFollowers} Seguidor${widget.publication.numFollowers > 1 ? "res" : ""}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      widget.bloc.dispatch(FeedButtonFollowPublicationPressed(
                          follow: FollowEntity(
                              publicationId: widget.publication.publicationId,
                              createdAt: DateTime.now().toIso8601String())));
                    },
                  ),
                )
              ],
            ),
            Container(
              color: Colors.white,
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
            )
          ],
        ),
      ),
    );
  }
}
