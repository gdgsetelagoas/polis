import 'dart:io';

import 'package:flutter/material.dart';

final urlRegex = RegExp(
    r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$");

class AppCircularImage extends StatelessWidget {
  final String path;
  final double size;
  final BoxFit fit;
  final BorderSide borderSide;
  final List<BoxShadow> shadows;

  const AppCircularImage(this.path,
      {Key key,
      this.size = 75.0,
      this.fit = BoxFit.cover,
      this.borderSide,
      this.shadows})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
          shadows: shadows,
          shape: CircleBorder(side: borderSide ?? BorderSide.none),
          image: DecorationImage(
              image: urlRegex.hasMatch(path)
                  ? NetworkImage(path)
                  : FileImage(File(path)),
              fit: fit)),
    );
  }
}
