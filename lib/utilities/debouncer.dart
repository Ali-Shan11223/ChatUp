import 'dart:async';

import 'package:flutter/animation.dart';

class Debouncer {
  final int milliSeconds;
  Timer? timer;
  Debouncer({required this.milliSeconds});

  run(VoidCallback action) {
    timer!.cancel();
    timer = Timer(Duration(milliseconds: milliSeconds), action);
  }
}
