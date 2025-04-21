import 'package:test/test.dart';
import 'package:output/output.dart';
import 'package:winsys/winsys.dart';

void main() {
  group('Run', () {
    test('run1', () {
      dump('start!');
      //command('ping', ['-n', '10', 'www.youtube.com']);
      //command$('ping', '-n', '10', 'www.youtube.com');
      command$('ping', '-n', rest: ['2', 'www.youtube.com']);
      tryCommand$('ping', '-n', rest: ['2', 'www.youtube.com']);
    });
    test('run2', () {
      dump('this is run2');
    });
  });
}
