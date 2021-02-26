import 'dart:typed_data';

/// Object representing a MacAddress in Byte form
class Bdaddr {
  Uint8List bytes = Uint8List(6);

  /// Parse a Mac Address String into a [Bdaddr]
  Bdaddr(String addr) {
    var parts = addr.split(':');
    bytes[0] = int.parse(parts[0], radix: 16);
    bytes[1] = int.parse(parts[1], radix: 16);
    bytes[2] = int.parse(parts[2], radix: 16);
    bytes[3] = int.parse(parts[3], radix: 16);
    bytes[4] = int.parse(parts[4], radix: 16);
    bytes[5] = int.parse(parts[5], radix: 16);
  }

  /// Create a [Bdaddr] from a List of Bytes
  Bdaddr.fromBytes(Uint8List bytes) {
    this.bytes = bytes;
  }

  Uint8List getBytes() {
    return Uint8List.fromList(bytes);
  }

  @override
  String toString() {
    return bytes.map((e) => e.toRadixString(16).toUpperCase()).join(':');
  }

  @override
  int get hashCode =>
      (bytes[0] & 0xff) ^
      ((bytes[1] & 0xff) << 8) ^
      ((bytes[2] & 0xff) << 16) ^
      ((bytes[3] & 0xff) << 24) ^
      (bytes[4] & 0xff) ^
      ((bytes[5] & 0xff) << 8);
}
