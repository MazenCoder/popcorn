import 'package:animator/animator.dart';
import 'package:flutter/material.dart';



class HeartAnime extends StatelessWidget {
  final double size;
  const HeartAnime({Key? key, this.size = 80.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Animator(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.5, end: 1.4),
      curve: Curves.elasticOut,
      builder: (context, anim, child) {
        final scale = anim.value as double;
        return Transform.scale(
          scale: scale,
          child: Icon(
            Icons.favorite,
            size: size,
            color: Colors.white54,
          ),
        );
      },
    );
  }
}
