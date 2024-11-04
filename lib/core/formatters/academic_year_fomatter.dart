import 'package:flutter/services.dart';

class AcademicYearFomatter extends TextInputFormatter {
  final String sample;
  final String seperator;

  AcademicYearFomatter({required this.sample, required this.seperator});
  
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.length > 0 ){
      if(newValue.text.length> oldValue.text.length){
        if(newValue.text.length > sample.length) return oldValue;
        if(newValue.text.length < sample.length && sample[newValue.text.length -1] == seperator) {
          return TextEditingValue(text: '${oldValue.text}$seperator${newValue.text.substring(newValue.text.length  -1)}', selection: TextSelection.collapsed(offset: newValue.selection.end + 1));
        }
      }
    }

    return newValue;
  }

}