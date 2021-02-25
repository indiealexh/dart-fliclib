import 'package:fliclib/fliclib.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    FlicClient flicClient;

    setUp(() {
      flicClient = FlicClient();
    });

    test('First Test', () async {
      await flicClient.connect();
      var getInfoEvent = await flicClient.getInfo();
      assert(getInfoEvent.bdAddr != null);
    });
  });
}
