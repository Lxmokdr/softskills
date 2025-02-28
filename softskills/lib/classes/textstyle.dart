import 'package:flutter/material.dart';
import 'package:softskills/classes/color.dart';
import 'package:google_fonts/google_fonts.dart';

class Textstyle {
  static final TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w300, // Light
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static final TextStyle darkText = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w300, // Light weight
    color: color.bgColor,
    decoration: TextDecoration.none,
  );

  static final TextStyle whiteText = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w400, // Regular weight
    color: Colors.white,
    decoration: TextDecoration.none,
  );

  static final TextStyle darkBlue = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w400, // Regular weight
    color: const Color(0xff091e3a),
    decoration: TextDecoration.none,
  );

  static final TextStyle formDarkBlue = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    color: const Color(0xff091e3a),
    decoration: TextDecoration.none,
  );

  static final TextStyle formWhite = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: Colors.white,
    decoration: TextDecoration.none,
  );

  static final TextStyle formBeige = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    color: color.beigeColor,
    decoration: TextDecoration.none,
  );

  static final TextStyle lightBlue = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w400, // Regular weight
    color: const Color.fromARGB(255, 104, 182, 250),
    decoration: TextDecoration.none,
  );

  static final TextStyle smallerWhiteText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular weight
    color: const Color.fromARGB(255, 255, 255, 255),
    decoration: TextDecoration.none,
  );

  static final TextStyle smallerDarkGreenText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular weight
    color: color.bgColor,
    decoration: TextDecoration.none,
  );

  static final TextStyle smallerDarkBlueText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular weight
    color: const Color(0xff091e3a),
    decoration: TextDecoration.none,
  );

  static final TextStyle smallerBlueText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular weight
    color: const Color.fromARGB(255, 104, 182, 250),
    decoration: TextDecoration.none,
  );
}
