import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimary = Color(0xFF7A001F);
const Color kBackground = Color(0xFFFBF7F4);
const Color kAccent = Color(0xFFD44F61);
const Color kTextDark = kPrimary;

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
  scaffoldBackgroundColor: kBackground,
  textTheme: GoogleFonts.nunitoTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBackground,
    foregroundColor: kTextDark,
    elevation: 0,
  ),
);