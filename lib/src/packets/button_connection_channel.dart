import 'dart:async';

import 'package:fliclib/src/packets/bdaddr.dart';
import 'package:fliclib/src/packets/enum/latency_mode.dart';

class ButtonConnectionChannel {
  static int _nextId = 0;

  static int getNextIdAndIncrement() => _nextId++;
  final int connId = getNextIdAndIncrement();

  final Bdaddr bdaddr;
  LatencyMode latencyMode;
  int autoDisconnectTime;
  Stream events;

  ButtonConnectionChannel(
      this.bdaddr, this.latencyMode, this.autoDisconnectTime);

  ButtonConnectionChannel.Normal(this.bdaddr) {
    latencyMode = LatencyMode.NormalLatency;
    autoDisconnectTime = 511;
  }
}
