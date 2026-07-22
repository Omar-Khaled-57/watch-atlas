import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CollageCover extends StatelessWidget {
  final List<String?> imageUrls;
  final double height;
  final double borderRadius;

  const CollageCover({
    super.key,
    required this.imageUrls,
    this.height = 180,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final urls = imageUrls.where((u) => u != null && u.isNotEmpty).take(4).toList();
    final colorScheme = Theme.of(context).colorScheme;

    if (urls.isEmpty) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(borderRadius),
            topEnd: Radius.circular(borderRadius),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadiusDirectional.only(
        topStart: Radius.circular(borderRadius),
        topEnd: Radius.circular(borderRadius),
      ),
      child: SizedBox(
        height: height,
        child: _buildLayout(urls.cast<String>()),
      ),
    );
  }

  Widget _buildLayout(List<String> urls) {
    switch (urls.length) {
      case 1:
        return _single(urls[0]);
      case 2:
        return _two(urls[0], urls[1]);
      case 3:
        return _three(urls[0], urls[1], urls[2]);
      default:
        return _four(urls[0], urls[1], urls[2], urls[3]);
    }
  }

  Widget _image(String url) => CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => const SizedBox(),
      );

  Widget _single(String url) => _image(url);

  Widget _two(String a, String b) => Row(
        children: [
          Expanded(child: _image(a)),
          Expanded(child: _image(b)),
        ],
      );

  Widget _three(String a, String b, String c) => Column(
        children: [
          Expanded(child: _image(a)),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _image(b)),
                Expanded(child: _image(c)),
              ],
            ),
          ),
        ],
      );

  Widget _four(String a, String b, String c, String d) => Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _image(a)),
                Expanded(child: _image(b)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _image(c)),
                Expanded(child: _image(d)),
              ],
            ),
          ),
        ],
      );
}
