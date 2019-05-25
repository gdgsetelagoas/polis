import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/bloc.dart';
import 'package:res_publica/ui/feed/widgets/feed_item_player.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

class ViewPublicationScreen extends StatefulWidget {
  final PublicationEntity publication;
  final int sourceIndex;
  final VideoPlayerController videoPlayerController;
  final FeedBloc bloc;

  const ViewPublicationScreen({
    Key key,
    @required this.publication,
    this.sourceIndex,
    this.videoPlayerController,
    @required this.bloc,
  })  : assert(publication != null),
        super(key: key);

  @override
  _ViewPublicationScreenState createState() => _ViewPublicationScreenState();
}

class _ViewPublicationScreenState extends State<ViewPublicationScreen> {
  UserEntity _user;
  PageController _pageController;
  TextEditingController _replyController = TextEditingController();

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
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${widget.publication.numReacts} Reaç${widget.publication.numReacts > 1 ? "ôes" : "ão"}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onLongPress: () {
//                    widget.bloc.dispatch(event)
                    },
                    onTap: () {
                      widget.bloc.dispatch(FeedButtonReactPublicationPressed(
                          react: ReactEntity(
                              publicationId:
                                  widget.publication.publicationId)));
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${widget.publication.numReplies} Comentário${widget.publication.numReplies > 1 ? "s" : ""}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "${widget.publication.numFollowers} Seguidor${widget.publication.numFollowers > 1 ? "res" : ""}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {},
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
                                reply:
                                    ReplyEntity(body: _replyController.text)));
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
