import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<ui.Image>? bytesToImage(List<int> intList) async {
  ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(intList));
  ui.FrameInfo frame = await codec.getNextFrame();
  return frame.image;
}


/*
Future<Image> getImageFromByteArray() async {
  final Completer<Image> completer = Completer<Image>();
  final bytes = Uint8List.fromList([
    137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0,
    1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 10, 73, 68, 65,
    84, 120, 156, 99, 0, 1, 0, 0, 5, 0, 1, 13, 10, 45, 180, 0, 0, 0, 0, 73,
    69, 78, 68, 174, 66, 96, 130 // prevent dartfmt
  ]);

  //final bytes = Uint8List.fromList(List<int>.filled(width * height * 4, 0xFF));

  // decodeImageFromPixels(bytes
  //   width,
  //   height,
  //   PixelFormat.rgba8888,
  //   // Don't worry about disposing or cloning this image - responsibility
  //   // is transferred to the caller, and that is safe since this method
  //   // will not touch it again.
  //   (Image image) => completer.complete(image),
  // );

  // copy from decodeImageFromList of package:flutter/painting.dart
  final codec = await instantiateImageCodec(bytes);
  final frameInfo = await codec.getNextFrame();
  completer.complete(frameInfo.image);
  // return result;

  return completer.future;
}
*/