import 'dart:io';
import 'dart:typed_data';

import 'package:fliclib/src/packets/bdaddr.dart';
import 'package:fliclib/src/packets/button_connection_channel.dart';

abstract class CommandPacket {
  final int opcode;
  BytesBuilder builder = BytesBuilder();

  CommandPacket(this.opcode) {
    builder.addByte(opcode);
  }

  void _writeInt8(int v) {
    builder.addByte(v);
  }

  void _writeInt16(int v) {
    _writeInt8(v & 0xff);
    _writeInt8(v >> 8);
  }

  void _writeInt32(int v) {
    _writeInt16(v);
    _writeInt16(v >> 16);
  }

  void _writeBdaddr(Bdaddr bdaddr) {
    bdaddr.bytes.reversed
        .forEach((element) => print(element.toRadixString(16)));
    bdaddr.bytes.reversed.forEach((element) => _writeInt8(element));
  }
}

/// Construct a TCP packet to request "GetInfo" from the FlicSDK server
class CmdGetInfo extends CommandPacket {
  CmdGetInfo() : super(0);
}

// class CmdCreateScanner extends CommandPacket {
//   final int scanId;
//   CmdCreateScanner(this.scanId) : super(1) {
//     _writeInt32(scanId);
//   }
// }
//
// class CmdCreateScanWizard extends CommandPacket {
//   final int scanId;
//   CmdCreateScanWizard(this.scanId) : super(9) {
//     _writeInt32(scanId);
//   }
// }

/// Construct a TCP packet to request "GetInfo" from the FlicSDK server
class CmdCreateConnectionChannel extends CommandPacket {
  final ButtonConnectionChannel buttonConnectionChannel;

  CmdCreateConnectionChannel(this.buttonConnectionChannel) : super(3) {
    _writeInt32(buttonConnectionChannel.connId);
    _writeBdaddr(buttonConnectionChannel.bdaddr);
    _writeInt8(buttonConnectionChannel.latencyMode.index);
    _writeInt16(buttonConnectionChannel.autoDisconnectTime);
  }
}
