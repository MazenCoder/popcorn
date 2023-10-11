import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/widgets_helper/responsive_safe_area.dart';
import 'package:flutter/material.dart';



class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSafeArea(
      builder: (_) => Scaffold(
        body: Stack(
          children: [
            Center(
              child: Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30.0,
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
