import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          Text(message),
        ],
      ),
    );
  }
}
