import 'dart:typed_data';

import 'package:fliclib/src/packets/bdaddr.dart';
import 'package:fliclib/src/packets/enum/bluetooth_addr_type.dart';
import 'package:fliclib/src/packets/enum/bluetooth_controller_state.dart';
import 'package:fliclib/src/packets/enum/click_type.dart';

abstract class EventPacket {
  final Uint8List pkt;
  int pos = 0;

  EventPacket(this.pkt) {
    parse(pkt);
  }

  void parse(Uint8List bytes);

  int _getUInt8() {
    return pkt[pos++];
  }

  int _getUint16() {
    return _getUInt8() | (_getUInt8() << 8);
  }

  int _getInt32() {
    return _getUInt8() |
        (_getUInt8() << 8) |
        (_getUInt8() << 16) |
        (_getUInt8() << 24);
  }

  bool _getBool() {
    return _getUInt8() != 0;
  }

  String _getString() {
    var len = _getUInt8();
    var s = String.fromCharCodes(Uint8List.sublistView(pkt, pos, len));
    pos += 16;
    return s;
  }

  Bdaddr _getBdAddr() {
    // Address is a fix length of 6 bytes represented as hex and should be printed separated by colons
    var addrBytes = Uint8List(6);
    addrBytes[5] = _getUInt8();
    addrBytes[4] = _getUInt8();
    addrBytes[3] = _getUInt8();
    addrBytes[2] = _getUInt8();
    addrBytes[1] = _getUInt8();
    addrBytes[0] = _getUInt8();
    return Bdaddr.fromBytes(addrBytes);
  }
}

class GetInfoEvent extends EventPacket {
  BluetoothControllerState bluetoothControllerState;
  Bdaddr bdAddr;
  BdAddrType bdAddrType;
  int maxPendingConnections;
  int maxConcurrentlyConnectedButtons;
  int currentPendingConnections;
  bool currentlyNoSpaceForNewConnections;
  int nbVerifiedButtons;
  List<Bdaddr> bdAddrOfVerifiedButtons;

  GetInfoEvent(Uint8List pkt) : super(pkt);

  @override
  void parse(Uint8List pkt) {
    bluetoothControllerState = BluetoothControllerState.values[_getUInt8()];
    bdAddr = _getBdAddr();
    bdAddrType = BdAddrType.values[_getUInt8()];
    maxPendingConnections = _getUInt8();
    maxConcurrentlyConnectedButtons = _getUint16();
    currentPendingConnections = _getUInt8();
    currentlyNoSpaceForNewConnections = _getBool();
    nbVerifiedButtons = _getUint16();
    bdAddrOfVerifiedButtons = [];
    for (var i = 0; i < nbVerifiedButtons; i++) {
      bdAddrOfVerifiedButtons.insert(i, _getBdAddr());
    }
  }

  @override
  String toString() {
    return '{ bluetoothControllerState: $bluetoothControllerState, bdAddr: $bdAddr, bdAddrType: $bdAddrType, maxPendingConnections: $maxPendingConnections, maxConcurrentlyConnectedButtons: $maxConcurrentlyConnectedButtons, currentPendingConnections: $currentPendingConnections, currentlyNoSpaceForNewConnections: $currentlyNoSpaceForNewConnections, nbVerifiedButtons: $nbVerifiedButtons, bdAddrOfVerifiedButtons: $bdAddrOfVerifiedButtons }';
  }
}

class ButtonEvent extends EventPacket {
  int connId;
  ClickType clickType;
  bool wasQueued;
  int timeDiff;

  ButtonEvent(Uint8List pkt) : super(pkt);

  @override
  void parse(Uint8List pkt) {
    connId = _getInt32();
    clickType = ClickType.values[_getUInt8()];
    wasQueued = _getBool();
    timeDiff = _getInt32();
  }
}
