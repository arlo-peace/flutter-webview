import 'package:app_frame/config.dart';
import 'package:flutter/material.dart';

class ProgressWithIcon extends StatelessWidget {
  const ProgressWithIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            // you can replace this with Image.asset
            loadIcon,
            fit: BoxFit.cover,
            height: 30,
            width: 30,
          ),
          // you can replace
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            strokeWidth: 0.7,
          ),
        ],
      ),
    );
  }
}