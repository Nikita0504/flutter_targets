import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trenning/theme/theme.dart';

import '../screens/settings.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = darkTheme;
  ThemeData get themeData => _themeData;
  bool theme = false;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {

    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_themeData == darkTheme){
      themeData = lightTheme;
      theme = true;
    } else {
      themeData = darkTheme;
      theme = false;
    }
  await _prefs.setBool('theme', theme);
  }

  initialize() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    theme = await _prefs.getBool('theme') ?? false;
   if(theme == true){
    Global.shared.state.stateS = true;
    themeData = lightTheme;
   }else{
    themeData = darkTheme;
   }
  }

}