import 'dart:core';
//import 'dart:io' as io;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;
import 'package:dynamic_function/dynamic_function.dart';
import 'package:misc/misc.dart' as misc;

final ffi.DynamicLibrary _msvcrtLib = ffi.DynamicLibrary.open('msvcrt.dll');

final int Function(ffi.Pointer<ffi.Utf16>) _wsystemFunc =
    _msvcrtLib
        .lookup<ffi.NativeFunction<ffi.Int32 Function(ffi.Pointer<ffi.Utf16>)>>(
          '_wsystem',
        )
        .asFunction();

int wsystem(String $commandLine) {
  final $strPtr = $commandLine.toNativeUtf16();
  int $exitCode = _wsystemFunc($strPtr);
  ffi.calloc.free($strPtr);
  return $exitCode;
}

int command(String cmd, List<String> cmdArgs, {bool? useBash}) {
  String $commandLine = misc.makeCommandLine([cmd, ...cmdArgs]);
  bool $withBash = (useBash == null) ? false : useBash;
  if ($withBash) {
    //$commandLine = 'bash -c "${$commandLine.replaceAll('"', '"""')}"';
    $commandLine = "bash -c '${$commandLine}'";
    print($commandLine);
  }
  //print($commandLine);
  return wsystem($commandLine);
}

void tryCommand(String cmd, List<String> cmdArgs, {bool? useBash}) {
  final $exitCode = command(cmd, cmdArgs, useBash: useBash);
  if ($exitCode != 0) {
    throw '$cmd $cmdArgs returned ${$exitCode}';
  }
}

final dynamic command$ = DynamicFunction((
  List<dynamic> $positional,
  Map<Symbol, dynamic> $named,
) {
  if ($positional.isEmpty) {
    throw '${$positional.length} arguments supplied to command\$()';
  }
  dynamic $cmd = $positional[0];
  List<String> $cmdArgs = <String>[];
  for (int $i = 1; $i < $positional.length; $i++) {
    $cmdArgs.add($positional[$i]);
  }
  checkNamed($named, ['rest', 'useBash']);
  List<String> $rest =
      ($named[Symbol('rest')] == null)
          ? <String>[]
          : $named[Symbol('rest')] as List<String>;
  for (int $i = 0; $i < $rest.length; $i++) {
    $cmdArgs.add($rest[$i]);
  }
  bool? $useBash =
      ($named[Symbol('useBash')] == null)
          ? null
          : $named[Symbol('useBash')] as bool?;
  return command($cmd, $cmdArgs, useBash: $useBash);
});

final dynamic tryCommand$ = DynamicFunction((
  List<dynamic> $positional,
  Map<Symbol, dynamic> $named,
) {
  if ($positional.isEmpty) {
    throw '${$positional.length} arguments supplied to command\$()';
  }
  dynamic $cmd = $positional[0];
  List<String> $cmdArgs = <String>[];
  for (int $i = 1; $i < $positional.length; $i++) {
    $cmdArgs.add($positional[$i]);
  }
  checkNamed($named, ['rest', 'useBash']);
  List<String> $rest =
      ($named[Symbol('rest')] == null)
          ? <String>[]
          : $named[Symbol('rest')] as List<String>;
  for (int $i = 0; $i < $rest.length; $i++) {
    $cmdArgs.add($rest[$i]);
  }
  bool? $useBash =
      ($named[Symbol('useBash')] == null)
          ? null
          : $named[Symbol('useBash')] as bool?;
  tryCommand($cmd, $cmdArgs, useBash: $useBash);
  return null;
});
