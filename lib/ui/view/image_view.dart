import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final String imageURL;
  const ImageView({super.key, required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
        imageProvider: NetworkImage(imageURL),
        minScale: PhotoViewComputedScale.contained);
  }
}
