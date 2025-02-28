import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:softskills/classes/color.dart';

class Loading2 extends StatelessWidget {
  const Loading2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: SpinKitCubeGrid(
          color: color.bgColor,
          size: 100,
        ),
      ),
    );
  }
}