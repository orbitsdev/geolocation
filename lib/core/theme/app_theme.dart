import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData UI = ThemeData(
    scaffoldBackgroundColor:Palette.LIGHT_BACKGROUND,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: Palette.PRIMARY,
      cursorColor: Palette.PRIMARY,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Palette.PRIMARY,
      
    ),
    textTheme:  GoogleFonts.robotoTextTheme().copyWith(
      titleLarge:  GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
        color: Palette.BLACK
      ),
      titleMedium:  GoogleFonts.robotoTextTheme().titleMedium!.copyWith(
        color: Palette.BLACK
      
      ),
      titleSmall:  GoogleFonts.robotoTextTheme().titleSmall!.copyWith(
        color: Palette.BLACK
      ),
      bodyLarge:  GoogleFonts.robotoTextTheme().bodyLarge!.copyWith(      
        color: Palette.BLACK
      ),
      bodyMedium:  GoogleFonts.robotoTextTheme().bodyMedium!.copyWith(
        color: Palette.BLACK
        
      ),
      bodySmall:  GoogleFonts.robotoTextTheme().bodySmall!.copyWith(
        color: Palette.BLACK
      
      ),
    ),
    colorSchemeSeed: Palette.PRIMARY,
    useMaterial3: true,
  );

  
}
