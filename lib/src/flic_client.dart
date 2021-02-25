import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:fliclib/src/packets/button_connection_channel.dart';
import 'package:fliclib/src/packets/command_packet.dart';
import 'package:fliclib/src/packets/enum/event_packet_type.dart';
import 'package:fliclib/src/packets/event_packet.dart';

class FlicClient {
  Socket _socket;

  bool get isSocketOpen => _socket != null;

  HashMap<int, ButtonConnectionChannel> connectionChannels = HashMap();

  FlicClient();

  void connect() async {
    print('connecting to flicsdk');
    _socket = await Socket.connect('127.0.0.1', 5551);
    print('connected to flicsdk');
    _socket.listen(
      handleEvent,
      onError: (error) => disconnect(error),
      onDone: () => disconnect('Server ended the connection'),
    );
  }

  Future<void> handleEvent(Uint8List packet) async {
    print('TCP Receive: ${EventPacketType.values[packet[2]].toString()}');
    var payload = packet.sublist(3);
    switch (EventPacketType.values[packet[2]]) {
      case EventPacketType.EVT_ADVERTISEMENT_PACKET_OPCODE:
        break;
      case EventPacketType.EVT_CREATE_CONNECTION_CHANNEL_RESPONSE_OPCODE:
        print(payload);
        break;
      case EventPacketType.EVT_CONNECTION_STATUS_CHANGED_OPCODE:
        break;
      case EventPacketType.EVT_CONNECTION_CHANNEL_REMOVED_OPCODE:
        break;
      case EventPacketType.EVT_BUTTON_UP_OR_DOWN_OPCODE:
      case EventPacketType.EVT_BUTTON_CLICK_OR_HOLD_OPCODE:
      case EventPacketType.EVT_BUTTON_SINGLE_OR_DOUBLE_CLICK_OPCODE:
      case EventPacketType.EVT_BUTTON_SINGLE_OR_DOUBLE_CLICK_OR_HOLD_OPCODE:
        print('Button Event');
        break;
      case EventPacketType.EVT_NEW_VERIFIED_BUTTON_OPCODE:
        break;
      case EventPacketType.EVT_GET_INFO_RESPONSE_OPCODE:
        Completer completer = awaitingGetInfoEvent.removeFirst();
        completer.complete(GetInfoEvent(payload));
        break;
      case EventPacketType.EVT_NO_SPACE_FOR_NEW_CONNECTION_OPCODE:
        break;
      case EventPacketType.EVT_GOT_SPACE_FOR_NEW_CONNECTION_OPCODE:
        break;
      case EventPacketType.EVT_BLUETOOTH_CONTROLLER_STATE_CHANGE_OPCODE:
        break;
      case EventPacketType.EVT_PING_RESPONSE_OPCODE:
        break;
      case EventPacketType.EVT_GET_BUTTON_INFO_RESPONSE_OPCODE:
        break;
      case EventPacketType.EVT_SCAN_WIZARD_FOUND_PRIVATE_BUTTON_OPCODE:
        break;
      case EventPacketType.EVT_SCAN_WIZARD_FOUND_PUBLIC_BUTTON_OPCODE:
        break;
      case EventPacketType.EVT_SCAN_WIZARD_BUTTON_CONNECTED_OPCODE:
        break;
      case EventPacketType.EVT_SCAN_WIZARD_COMPLETED_OPCODE:
        break;
      case EventPacketType.EVT_BUTTON_DELETED_OPCODE:
        break;
      case EventPacketType.EVT_BATTERY_STATUS_OPCODE:
        break;
      default:
        throw UnsupportedError('Packet type is not supported');
        break;
    }
  }

  void disconnect(dynamic message) {
    print(message);
    if (isSocketOpen) {
      _socket.destroy();
      _socket = null;
    } else {
      print('Requested disconnect on null socket');
    }
  }

  void writeToSocket(CommandPacket commandPacket) async {
    if (isSocketOpen) {
      var packet = Uint8List(2 + commandPacket.builder.length);
      packet[0] = commandPacket.builder.length & 0xff;
      packet[1] = commandPacket.builder.length >> 8;
      packet.setAll(2, commandPacket.builder.toBytes());
      print('Packet out: $packet');
      _socket.add(packet);
    } else {
      throw SocketException('No open socket, please start a new connection');
    }
  }

  DoubleLinkedQueue<Completer<EventPacket>> awaitingGetInfoEvent =
      DoubleLinkedQueue();

  // Get current flic server status
  Future<GetInfoEvent> getInfo() async {
    CommandPacket commandPacket = CmdGetInfo();
    writeToSocket(commandPacket);
    var completer = Completer<GetInfoEvent>();
    awaitingGetInfoEvent.add(completer);
    var result = await completer.future.timeout(Duration(seconds: 5));
    // Result is the response or a timeout exception
    return result;
  }

  Future<void> addConnectionChannel(ButtonConnectionChannel channel) async {
    var pkt = CmdCreateConnectionChannel(channel);
    writeToSocket(pkt);
  }
}
