import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ffi';

typedef CRecoder = ffi.Int64 Function(Int32 seconds);
typedef DartRecoder = int Function(int seconds);

class Recoder {
  FutureOr<int> recoder(int seconds) {
  final recLib = ffi.DynamicLibrary.open('external/c++/build/librec.so');
    final rec = recLib.lookupFunction<CRecoder, DartRecoder>('rec');
    return rec(seconds);
  }
}
