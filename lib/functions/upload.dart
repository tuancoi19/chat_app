import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart';

Future uploadAvatar(String name, String pathin) async {
  final path = 'avatar/avatar$name';
  final file = File(pathin);
  final storage = FirebaseStorage.instance.ref().child(path);

  await storage.putFile(file);
  final url = await storage.getDownloadURL();
  return url;
}

Future uploadImage(XFile data) async {
  final path = 'image/${data.name}';
  final file = File(data.path);
  final storage = FirebaseStorage.instance.ref().child(path);

  await storage.putFile(file);
  final url = await storage.getDownloadURL();
  return url;
}

Future uploadVideo(XFile data) async {
  final path = 'video/${data.name}';
  final file = File(data.path);
  final storage = FirebaseStorage.instance.ref().child(path);

  final thumbnail = await VideoThumbnail.thumbnailFile(
    video: data.path,
    thumbnailPath: (await getTemporaryDirectory()).path,
    maxHeight: 150,
    maxWidth: 246,
  );

  await FirebaseStorage.instance
      .ref()
      .child('thumbnail/$thumbnail')
      .putFile(File(thumbnail!));

  await storage.putFile(file);
  final thumbnailURL = await FirebaseStorage.instance
      .ref()
      .child('thumbnail/$thumbnail')
      .getDownloadURL();

  final url = await storage.getDownloadURL();
  return {'videoURL': url, 'thumbnailURL': thumbnailURL};
}

Future uploadAudio(File data) async {
  final path = 'audio/${basename(data.path)}';
  final storage = FirebaseStorage.instance.ref().child(path);

  await storage.putFile(data);
  final url = await storage.getDownloadURL();
  return url;
}
