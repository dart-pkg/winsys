import 'package:test/test.dart';
import 'package:output/output.dart';
import 'package:winsys/winsys.dart' as winsys;

void main() {
  group('Run', () {
    test('run1', () {
      dump('start!');
      winsys.command$(
        'dart',
        'pub',
        'deps',
        '--no-dev',
        '--style',
        'list',
        '|',
        'sed',
        //"'/^ .*/d'",
        '"/^ .*/d"',
        useBash: true,
      );
      // winsys.wsystem(
      //   'dart pub deps --no-dev --style list | sed "/^ .*/d"',
      //   useBash: true,
      // );
    });
  });
}
