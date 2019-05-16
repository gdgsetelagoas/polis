import 'package:flutter/material.dart';

class AppLoading extends StatefulWidget {
  final Widget child;
  final bool processing;
  final Future Function() onTapCancel;
  final Color background;
  final Color progressColor;
  final Duration duration;
  final Stream<bool> stream;

  const AppLoading(
      {Key key,
      this.processing,
      this.onTapCancel,
      this.child,
      this.background,
      this.progressColor,
      this.duration,
      this.stream})
      : super(key: key);

  @override
  _AppLoadingState createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _alphaNum;
  Animation<double> _posNum;
  bool _show = false;
  bool _showStream = false;

  @override
  void initState() {
    _controller = AnimationController(
        duration: widget.duration ?? const Duration(milliseconds: 500),
        vsync: this);
    _alphaNum = IntTween(begin: 0, end: 100).animate(_controller)
      ..addListener(() => setState(() {}));
    final Animation curve =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
    _posNum = Tween<double>(begin: -1.0, end: 0.0).animate(curve)
      ..addListener(() => setState(() {}));
    widget.stream?.listen((isToShow) {
      _showStream = isToShow;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasChange()) {
      if (_isForward())
        _controller.forward();
      else
        _controller.reverse();
    }
    return Container(
      child: Stack(
        children: <Widget>[
          widget.child,
          _show || _controller.isAnimating
              ? Container(
                  color: (widget.background ?? Theme.of(context).primaryColor)
                      .withAlpha(_alphaNum.value),
                  child: Center(),
                )
              : Container(),
          _show || _controller.isAnimating
              ? Align(
                  alignment: Alignment(0, _posNum.value),
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          widget.progressColor ??
                              Theme.of(context).accentColor)))
              : Container()
        ],
      ),
    );
  }

  bool _isForward() {
    var old = _show;
    _show = widget.processing ?? _showStream;
    return !old;
  }

  bool _hasChange() {
    return _show != widget.processing ?? _showStream;
  }
}
