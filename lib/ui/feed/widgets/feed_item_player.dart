import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FeedItemPlayer extends StatefulWidget {
  final String url;

  const FeedItemPlayer({Key key, @required this.url})
      : assert(url != null),
        super(key: key);

  @override
  _FeedItemPlayerState createState() => _FeedItemPlayerState();
}

class _FeedItemPlayerState extends State<FeedItemPlayer>
    with SingleTickerProviderStateMixin {
  Animation<int> _alpha;
  VideoPlayerController _videoController;
  AnimationController _animationController;
  double _videoProgress = 0.0;
  String _time = "00:00/00:00";

  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) => setState(() {}))
      ..addListener(_videoListener)
      ..setLooping(true);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    _alpha = IntTween(begin: 255, end: 0).animate(_animationController)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(child: VideoPlayer(_videoController)),
          LinearProgressIndicator(
            value: _videoProgress,
            backgroundColor: Colors.grey,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(
                  _videoController.value.isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 64.0,
                  color: Theme.of(context).primaryColor.withAlpha(_alpha.value),
                ),
                onPressed: () {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                    _animationController.reset();
                  } else {
                    _videoController.play();
                    _animationController.forward();
                  }
                }),
          ),
          Align(
            alignment: Alignment(1.0, -0.97),
            child: Opacity(
              opacity: _alpha.value.toDouble() / 255.0,
              child: Container(
                padding: EdgeInsets.all(4.0),
                color: Colors.black26,
                child: Text(
                  _time,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _videoListener() {
    try {
      _videoProgress = _videoController.value.position.inMilliseconds /
          _videoController.value.duration.inMilliseconds;
    } catch (e) {
      _videoProgress = 0.0;
    }
    if (mounted) setState(() {});
    _time =
        "${_printDuration(_videoController.value.position)}/${_printDuration(_videoController.value.duration)}";
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 1 ? twoDigits(duration.inHours) + ":" : ""}$twoDigitMinutes:$twoDigitSeconds";
  }
}
