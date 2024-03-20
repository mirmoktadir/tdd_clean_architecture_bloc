import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedStatus extends StatelessWidget {
  const AnimatedStatus({
    super.key,
    required this.height,
    required this.name,
  });
  final double height;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/$name.json',
        height: height,
        repeat: true,
        reverse: true,
        fit: BoxFit.cover,
      ),
    );
  }
}
