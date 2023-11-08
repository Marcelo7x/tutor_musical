import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ffi';

typedef CRecoder = ffi.Int64 Function(ffi.Int64 seconds, ffi.Int64 initDelay, ffi.Bool withMetronome, ffi.Int32 bpm);
typedef DartRecoder = int Function(int seconds, int initDelay, bool withMetronome, int bpm);

class Recoder {
  FutureOr<int> recoder(List<dynamic> args) {
    int seconds = args[0] as int;
    int initDelay = args[1] as int;
    bool withMetronome = args[2] as bool;
    int bpm = args[3] as int;
  final recLib = ffi.DynamicLibrary.open('external/c++/build/librec.so');
    final rec = recLib.lookupFunction<CRecoder, DartRecoder>('rec');
    return rec(seconds, initDelay, withMetronome, bpm);
  }
}
