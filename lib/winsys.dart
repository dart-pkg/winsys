import 'dart:core';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;

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
