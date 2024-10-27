import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff091e3a),
      child: const Center(
        child: SpinKitCubeGrid(
          color: Color.fromARGB(255, 255, 255, 255),
          size: 100,
        ),
      ),
    );
  }
}