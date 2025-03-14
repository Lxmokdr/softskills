import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:softskills/classes/color.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.bgColor,
      child: const Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}