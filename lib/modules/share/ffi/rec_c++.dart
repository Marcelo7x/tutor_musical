import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ffi';

typedef CRecoder = ffi.Void Function(Int32 seconds);
typedef DartRecoder = void Function(int seconds);

class Recoder {
  FutureOr recoder(int seconds) {
  final recLib = ffi.DynamicLibrary.open('external/c++/build/librec.so');
    final rec = recLib.lookupFunction<CRecoder, DartRecoder>('rec');
    rec(seconds);
  }
}
