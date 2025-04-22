import 'package:test/test.dart';
import 'package:output/output.dart';
import 'package:winsys/winsys.dart';

void main() {
  group('Run', () {
    test('run1', () {
      dump('start!');
      //command$('pubspec', '"1.0.0"', useBash: true);
      tryCommand$('pubspec', '"1.0.0"', useBash: true);
    });
    test('run2', () {
      dump('this is run2');
    });
  });
}
