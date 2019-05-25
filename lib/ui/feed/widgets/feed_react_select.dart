import 'package:flutter/material.dart';
import 'package:res_publica/model/react_entity.dart';

class FeedReactSelect extends StatefulWidget {
  final Offset offset;

  const FeedReactSelect({Key key, @required this.offset}) : super(key: key);

  @override
  _FeedReactSelectState createState() => _FeedReactSelectState();
}

class _FeedReactSelectState extends State<FeedReactSelect>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    print("Offset: ${widget.offset}");
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            child: Center(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            onTapDown: (_) {
              Navigator.of(context).pop();
            },
          ),
          Positioned(
            left: widget.offset.dx,
            top: widget.offset.dy - 100.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 4.5),
                        blurRadius: 3.5)
                  ]),
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ReactType.values
                    .map((type) => IconButton(
                        icon: Text(
                          ReactEntity(type: type).symbol,
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(ReactEntity(type: type));
                        }))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
