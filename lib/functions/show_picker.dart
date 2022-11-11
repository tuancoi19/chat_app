import 'dart:io';

import 'package:chat_app/commons/app_commons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showImagePicker(ImageSource source) async {
  XFile? file = await ImagePicker().pickImage(source: source);
  if (file != null) {
    return file;
  }
}

showVideoPicker(ImageSource source) async {
  XFile? file = await ImagePicker().pickVideo(source: source);
  if (file != null) {
    return file;
  }
}

showPicker() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: false);

  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  }
}

chooseAttachment(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading: const Icon(Icons.image),
            title: Text('Image', style: TextStyle(color: textColor)),
            onTap: () async {
              var source = await chooseSource(context);
              Future.delayed(
                  Duration.zero,
                  () => Navigator.of(context)
                      .pop({'type': 'Image', 'source': source}));
            }),
        ListTile(
            leading: const Icon(Icons.video_file),
            title: Text('Video', style: TextStyle(color: textColor)),
            onTap: () async {
              var source = await chooseSource(context);
              Future.delayed(
                  Duration.zero,
                  () => Navigator.of(context)
                      .pop({'type': 'Video', 'source': source}));
            }),
        ListTile(
            leading: const Icon(Icons.audio_file),
            title: Text('Audio', style: TextStyle(color: textColor)),
            onTap: () => Navigator.of(context).pop({'type': 'Audio'})),
        ListTile(
            leading: const Icon(Icons.folder),
            title: Text('File', style: TextStyle(color: textColor)),
            onTap: () => Navigator.of(context).pop({'type': 'File'})),
      ],
    ),
  );
}

chooseSource(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text('Camera', style: TextStyle(color: textColor)),
            onTap: () => Navigator.of(context).pop(ImageSource.camera)),
        ListTile(
            leading: const Icon(Icons.image),
            title: Text('Gallery', style: TextStyle(color: textColor)),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery)),
      ],
    ),
  );
}
