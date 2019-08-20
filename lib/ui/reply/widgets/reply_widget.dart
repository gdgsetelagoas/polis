import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:res_publica/model/reply_entity.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final bool _shimmer;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const ReplyWidget({Key key, @required this.reply, this.padding, this.margin})
      : assert(reply != null, "Reply must be not null"),
        this._shimmer = false,
        super(key: key);

  ReplyWidget.shimmer({Key key, this.padding, this.margin})
      : this.reply = null,
        this._shimmer = true,
        super(key: key);

  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    // widget.bloc.dispatch(FeedLoadUserData(userId: widget.publication.userId));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._shimmer)
      return _MyShimmer(
        padding: widget.padding,
        margin: widget.margin,
      );
    return Container(
      padding: widget.padding,
      margin: widget.margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(""),
            backgroundColor: Theme.of(context).accentColor,
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                      shape: BoxShape.rectangle),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Nome",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Center(
                          child: widget.reply?.resources?.isNotEmpty ?? false
                              ? Image.network(
                                  widget.reply.resources.first.resource)
                              : SizedBox(),
                        ),
                      ), // se houver
                      MarkdownBody(
                        data: widget.reply.body ?? "",
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(timeago.format(
                        DateTime.tryParse(widget.reply.createdAt),
                        locale: "pt_BR")),
                    Spacer(flex: 1),
                    Text("Reagir"),
                    Spacer(flex: 1),
                    Text("Responder"),
                    Spacer(flex: 4),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MyShimmer extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;

  const _MyShimmer({Key key, this.padding, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Theme.of(context).accentColor,
      child: Container(
        padding: padding,
        margin: margin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(""),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.0),
                          shape: BoxShape.rectangle),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                      )),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.0),
                        color: Colors.black,
                        child: SizedBox(
                          height: 14.0,
                          width: 24,
                        ),
                      ),
                      Spacer(flex: 1),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.0),
                        color: Colors.black,
                        child: SizedBox(
                          height: 14.0,
                          width: 40,
                        ),
                      ),
                      Spacer(flex: 1),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.0),
                        color: Colors.black,
                        child: SizedBox(
                          height: 14.0,
                          width: 60,
                        ),
                      ),
                      Spacer(flex: 4),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
