import 'dart:async';
import 'dart:ffi' as ffi;

typedef CRecoder = ffi.Void Function();
typedef DartRecoder = void Function();

class Recoder {
  FutureOr recoder(i) {
  final recLib = ffi.DynamicLibrary.open('external/c++/build/librec.so');
    final rec = recLib.lookupFunction<CRecoder, DartRecoder>('rec');
    rec();
  }
}
