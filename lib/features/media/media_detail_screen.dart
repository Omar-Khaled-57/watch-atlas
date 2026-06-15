import 'package:flutter/material.dart';

class MediaDetailScreen extends StatelessWidget {
  final String mediaId;

  const MediaDetailScreen({super.key, required this.mediaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Media $mediaId')),
      body: Center(
        child: Text('Media Detail: $mediaId'),
      ),
    );
  }
}
