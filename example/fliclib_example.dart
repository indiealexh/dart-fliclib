import 'package:fliclib/fliclib.dart';

void main() {
  run();
}

void run() async {
  var client = FlicClient();
  await client.connect();
  var info = await client.getInfo();
  print(info.toString());

  info.bdAddrOfVerifiedButtons.forEach((element) {
    var channel = ButtonConnectionChannel.Normal(element);
    client.addConnectionChannel(channel);
    print('Add channel for ${channel.bdaddr.toString()}');
  });
}
