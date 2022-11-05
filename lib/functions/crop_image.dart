import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

cropImage(File imageFile) async {
  CroppedFile? croppedFile = await ImageCropper()
      .cropImage(sourcePath: imageFile.path, maxHeight: 100, maxWidth: 100);
  if (croppedFile != null) {
    return croppedFile.path;
  }
}
