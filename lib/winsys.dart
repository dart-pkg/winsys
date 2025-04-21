import 'dart:core';
//import 'dart:io' as io;
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;
import 'package:dynamic_function/dynamic_function.dart';

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

int command(String $cmd, List<String> $cmdArgs) {
  String $commandLine = $cmd;
  for (int i = 0; i < $cmdArgs.length; i++) {
    $commandLine += ' "${$cmdArgs[i]}"';
  }
  return wsystem($commandLine);
}

void tryCommand(String $cmd, List<String> $cmdArgs) {
  final $exitCode = command($cmd, $cmdArgs);
  if ($exitCode != 0) {
    throw '${$cmd} ${$cmdArgs} returned ${$exitCode}';
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
  checkNamed($named, ['rest']);
  List<String> $rest =
  ($named[Symbol('rest')] == null)
      ? <String>[]
      : $named[Symbol('rest')] as List<String>;
  for (int $i=0; $i<$rest.length; $i++) {
    $cmdArgs.add($rest[$i]);
  }
  return command($cmd, $cmdArgs);
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
  checkNamed($named, ['rest']);
  List<String> $rest =
  ($named[Symbol('rest')] == null)
      ? <String>[]
      : $named[Symbol('rest')] as List<String>;
  for (int $i=0; $i<$rest.length; $i++) {
    $cmdArgs.add($rest[$i]);
  }
  tryCommand($cmd, $cmdArgs);
  return null;
});
