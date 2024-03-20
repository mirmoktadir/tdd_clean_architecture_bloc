import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'animated_status.dart';

class NetworkImageBox extends StatelessWidget {
  const NetworkImageBox({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    required this.radius,
  });

  final String url;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) =>
          const AnimatedStatus(height: 120, name: LottieName.kImageLoader),
      errorWidget: (context, url, error) => Container(
        height: 300,
        width: 300,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffF3F3F3),
          border: Border.all(color: Colors.white, width: 1),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          AppImages.kNoImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
