import 'package:test/test.dart';
import 'package:output/output.dart';

void main() {
  group('Run', () {
    test('run1', () {
      dump('start!');
    });
    test('run2', () {
      dump('this is run2');
    });
  });
}
