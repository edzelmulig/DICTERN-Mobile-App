import 'package:flutter/widgets.dart';

class ScreenUtil {
  final double height;
  final double width;

  ScreenUtil._(this.height, this.width);

  static ScreenUtil of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScreenUtil._(size.height, size.width);
  }
}
