import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:random_color/random_color.dart';

class StartupIdea {
  WordPair pair;
  String motto;
  Color _companyColor;

  // comp color

  StartupIdea(WordPair p, String m) {
    pair = p;
    motto = m;
    _companyColor = RandomColor().randomColor();
  }

  Color getCompanyColor(){
    return _companyColor;
  }

  String getCompanyColorName(){
    return getColorNameFromColor(_companyColor).getName;
  }

  String getColorHex(){
    return  _companyColor.toString().substring(10, 16).toUpperCase();
  }
}