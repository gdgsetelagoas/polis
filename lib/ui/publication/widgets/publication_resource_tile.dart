import 'dart:io';

import 'package:flutter/material.dart';
import 'package:res_publica/model/publication_entity.dart';
import 'package:res_publica/ui/utils/patterns.dart';
import 'package:video_player/video_player.dart';

class PublicationResourceTile extends StatefulWidget {
  final PublicationResource resource;
  final Function onPressed;

  const PublicationResourceTile(
      {Key key, @required this.resource, this.onPressed})
      : super(key: key);

  @override
  _PublicationResourceTileState createState() =>
      _PublicationResourceTileState();
}

class _PublicationResourceTileState extends State<PublicationResourceTile> {
  VideoPlayerController _videoController;
  bool _isPlay = false;

  @override
  void initState() {
    _videoController = (isHttp.hasMatch(widget.resource.resource)
        ? VideoPlayerController.network(widget.resource.resource)
        : VideoPlayerController.file(File(widget.resource.resource)))
      ..initialize().then((_) {
        _videoController.setLooping(true);
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
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: <Widget>[
          widget.resource.type == PublicationResourceType.IMAGE
              ? Image.file(
                  File(widget.resource.resource),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                )
              : VideoPlayer(_videoController),
          Center(
            child: widget.resource.type == PublicationResourceType.IMAGE
                ? Container()
                : IconButton(
                    icon: Icon(
                      _isPlay
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      color: Theme.of(context).primaryColor,
                      size: 48.0,
                    ),
                    onPressed: () {
                      if (_isPlay) {
                        _videoController.pause();
                      } else {
                        _videoController.play();
                      }
                      _isPlay = !_isPlay;
                      setState(() {});
                    }),
          ),
          Positioned(
            right: 0,
            child: IconButton(
                icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                tooltip: "Remover Imagem",
                onPressed: widget.onPressed),
          )
        ],
      ),
    );
  }
}
