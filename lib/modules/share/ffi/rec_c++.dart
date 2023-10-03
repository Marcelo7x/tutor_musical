import 'dart:ffi' as ffi;

typedef CRecoder = ffi.Void Function();
typedef DartRecoder = void Function();

class Recoder {
  final recLib = ffi.DynamicLibrary.open('external/c++/build/librec.so');
  void recoder() {
    final rec = recLib.lookupFunction<CRecoder, DartRecoder>('rec');
    rec();
  }
}
