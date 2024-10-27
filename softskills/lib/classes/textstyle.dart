import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';

class Textstyle {
  static const TextStyle bodyText = TextStyle(
    fontSize: 24,
    color: Colors.black,
    decoration: TextDecoration.none
  );

  static const TextStyle darkText = TextStyle(
    fontSize: 24,
    color: color.bgColor,
    decoration: TextDecoration.none
  );

    static const TextStyle whiteText = TextStyle(
    fontSize: 24,
    color: Colors.white,
    decoration: TextDecoration.none
  );

  static const TextStyle darkBlue = TextStyle(
    fontSize: 24,
    color: Color(0xff091e3a),
    decoration: TextDecoration.none
  );

    static const TextStyle formDarkBlue = TextStyle(
    fontSize: 20,
    color: Color(0xff091e3a),
    decoration: TextDecoration.none,
    fontWeight: FontWeight.bold
  );
  
  static const TextStyle formWhite = TextStyle(
    fontSize: 16,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.w700
  );

  static const TextStyle lightBlue = TextStyle(
    fontSize: 24,
    color: Color.fromARGB(255, 104, 182, 250),
    decoration: TextDecoration.none
  );

  static const TextStyle smallerWhiteTexte = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 255, 255, 255),
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal
  );

  static const TextStyle smallerDarkGreenTexte = TextStyle(
    fontSize: 18,
    color: color.bgColor,
    decoration: TextDecoration.none
  );

  static const TextStyle smallerDarkBlueTexte = TextStyle(
    fontSize: 18,
    color: Color(0xff091e3a),
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle smallerBlueTexte = TextStyle(
    fontSize: 18,
    color: Color.fromARGB(255, 104, 182, 250),
    decoration: TextDecoration.none
  );
}
