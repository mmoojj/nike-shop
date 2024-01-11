import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageurl;
  final BorderRadius? borderRadius;

  ImageLoadingService({super.key, required this.imageurl, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageurl,
        fit: BoxFit.cover,
      ),
    );
  }
}
