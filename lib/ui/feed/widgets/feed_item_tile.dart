import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:res_publica/model/follow_entity.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/model/react_entity.dart';
import 'package:res_publica/model/user_entity.dart';
import 'package:res_publica/ui/feed/bloc/bloc.dart';
import 'package:res_publica/ui/feed/widgets/feed_item_player.dart';
import 'package:res_publica/ui/feed/widgets/feed_react_select.dart';
import 'package:res_publica/ui/publication/view_post_screen.dart';
import 'package:res_publica/ui/widgets/app_circular_imagem.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedItemTile extends StatefulWidget {
  final PublicationEntity publication;
  final UserEntity user;
  final FeedTileBloc bloc;
  final bool hideHeader;
  final bool bodyExpanded;

  const FeedItemTile(
      {Key key,
      @required this.publication,
      @required this.bloc,
      @required this.user,
      this.hideHeader = false,
      this.bodyExpanded = false})
      : super(key: key);

  @override
  _FeedItemTileState createState() => _FeedItemTileState();
}

class _FeedItemTileState extends State<FeedItemTile> {
  UserEntity _user;
  GlobalKey _reactButtonKey = GlobalKey();
  ReactEntity _userReact;

  @override
  void initState() {
    if (!widget.hideHeader)
      widget.bloc.add(FeedLoadUserData(userId: widget.publication.userId));
    widget.bloc.add(
        FeedLoadReactForPublicationStatus(publication: widget.publication));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: BlocBuilder(
              bloc: widget.bloc,
              condition: (oldState, newState) => newState is FeedUserDataLoaded,
              builder: (context, cardState) {
                if (cardState is FeedUserDataLoaded)
                  _user = cardState.user;
                else
                  _user = null;
                return widget.hideHeader
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppCircularImage(
                              _user?.photo ?? "",
                              size: 48.0,
                              fit: BoxFit.cover,
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2.5),
                              shadows: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 0.5),
                                    blurRadius: 2.5)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _user?.name ?? "🔌 Carregando..",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                  maxLines: 1,
                                ),
                                Text(
                                    "  ${timeago.format(widget.publication.createdAt, locale: "pt_BR")}"),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            itemBuilder: (c) {
                              if (widget.user != null &&
                                  widget.user.userId ==
                                      widget.publication.userId)
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
                            tooltip: "Mais Opções",
                            onSelected: (item) {
                              widget.bloc.add(
                                  FeedButtonMenuItemPressed(option: item));
                            },
                          ),
                        ],
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, right: 16.0, left: 16.0, bottom: 8.0),
            child: MarkdownBody(
              data: widget.publication.subtitle.length < 150 || widget.bodyExpanded
                  ? widget.publication.subtitle
                  : widget.publication.subtitle.substring(0, 139).trim() +
                      "... [ver mais](#vermais)",
              onTapLink: (link) {
                if (link == "#vermais")
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => ViewPublicationScreen(
                            publication: widget.publication,
                            bloc: widget.bloc,
                          )));
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
                onPageChanged: (page) {},
                itemBuilder: (context, index) {
                  var res = widget.publication.resources[index];
                  if (res.type == PublicationResourceType.IMAGE)
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => ViewPublicationScreen(
                                  publication: widget.publication,
                                  bloc: widget.bloc,
                                  sourceIndex: index,
                                )));
                      },
                      child: Container(
                        color: Colors.grey.shade300,
                        child: Image.network(
                          res.source,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  return FeedItemPlayer(url: res.source);
                }),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocBuilder(
                bloc: widget.bloc,
                condition: (oldState, newState) {
                  if (newState is FeedProcessingReactInPublication ||
                      newState is FeedReactInPublicationsFail) return true;

                  if (newState is FeedReactInPublicationsSuccess) {
                    _userReact = newState.react;
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return Expanded(
                    key: _reactButtonKey,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "${widget.publication.numReacts} Reaç${widget.publication.numReacts > 1 ? "ões" : "ão"}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight:
                                    (state is FeedReactInPublicationsSuccess) &&
                                            _userReact != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    state is FeedProcessingReactInPublication &&
                                            state.processing
                                        ? Colors.black12
                                        : Colors.black),
                          ),
                        ),
                      ),
                      onLongPress: state is FeedProcessingReactInPublication &&
                              state.processing
                          ? null
                          : () async {
                              if (state is FeedReactInPublicationsSuccess &&
                                  _userReact == null) return;
                              var react = await showDialog<ReactEntity>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (con) {
                                    RenderBox renderReactButton =
                                        _reactButtonKey.currentContext
                                            .findRenderObject();
                                    return FeedReactSelect(
                                        offset: renderReactButton
                                            .localToGlobal(Offset.zero));
                                  });
                              if (react != null)
                                widget.bloc.add(
                                    FeedButtonReactPublicationPressed(
                                        react: react
                                          ..publicationId =
                                              widget.publication.publicationId
                                          ..createdAt = DateTime.now()
                                              .toIso8601String()));
                            },
                      onTap: state is FeedProcessingReactInPublication &&
                              state.processing
                          ? null
                          : () {
                              widget.bloc.add(
                                  FeedButtonReactPublicationPressed(
                                      react: _userReact == null
                                          ? ReactEntity(
                                              publicationId: widget
                                                  .publication.publicationId,
                                              type: ReactType.LIKE,
                                              createdAt: DateTime.now()
                                                  .toIso8601String())
                                          : _userReact));
                            },
                    ),
                  );
                },
              ),
              Expanded(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "${widget.publication.numReplies} Comentário${widget.publication.numReplies > 1 ? "s" : ""}",
                        textAlign: TextAlign.center,
                      ),
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
                    child: Center(
                      child: Text(
                        "${widget.publication.numFollowers} Seguidor${widget.publication.numFollowers > 1 ? "res" : ""}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: widget.user == null
                      ? _loginDialog
                      : widget.user.userId == widget.publication.userId
                          ? null
                          : () {
                              widget.bloc.add(
                                  FeedButtonFollowPublicationPressed(
                                      follow: FollowEntity(
                                          publicationId:
                                              widget.publication.publicationId,
                                          createdAt: DateTime.now()
                                              .toIso8601String())));
                            },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _loginDialog() {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text("Entrar"),
              content:
                  Text("Você precisa de está logado para completar essa ação"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      widget.bloc
                          .add(FeedButtonSignInPublicationPressed());
                      Navigator.of(context).pop();
                    },
                    child: Text("Registrar")),
                FlatButton(
                    onPressed: () {
                      widget.bloc
                          .add(FeedButtonSignUpPublicationPressed());
                      Navigator.of(context).pop();
                    },
                    child: Text("Entrar"))
              ],
            ));
  }
}
