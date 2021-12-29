import 'package:flutter/foundation.dart';

@immutable
class Size {
  final double width;
  final double height;

  const Size({required this.width, required this.height});

  List<double> toList() {
    return [width, height];
  }
}
