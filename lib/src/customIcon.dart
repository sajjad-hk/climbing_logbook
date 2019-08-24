import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final String path;
  final Color color;
  final double size;

  CustomIcon({@required this.path, @required this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return ImageIcon(
        AssetImage(path),
        color: color,
        size: size ?? constraint.biggest.height,
      );
    });
  }
}
