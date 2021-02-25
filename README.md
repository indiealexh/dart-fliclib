# Fliclib

A dart version of the Shortcut Labs Flic button protocol

Please see the [official Flic developer docs](https://github.com/50ButtonsEach/flic2-documentation) for more info

## Device support

### Currently supported

- [Windows via FlicSDK](https://github.com/50ButtonsEach/fliclib-windows)
- [Linux via FlicSDK](https://github.com/50ButtonsEach/fliclib-linux-hci)

### Planned support

- Android via Flutter
- iOS via Flutter

## Usage

You will need the FlicSDK running and have already connected the Flic buttons you wish to use

A simple usage example:

```dart
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
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/indiealexh/dart-fliclib/issues


## License

Dart Fliclib by Alexander Haslam is licensed under CC BY 4.0 