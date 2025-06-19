import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  NavigatorState get navi => Navigator.of(this);

  Future<T?> push<T>(Widget Function(BuildContext) builder) => navi.push<T>(
    MaterialPageRoute<T>(builder: (context) => builder(context)),
  );

  void pop<T>([T? result]) => navi.pop<T>(result);
}
