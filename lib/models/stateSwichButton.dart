import 'package:shared_preferences/shared_preferences.dart';

class StateSwich{
  bool stateS = false;
  StateSwich(this.stateS);
  void checkState() async {
final SharedPreferences _prefs = await SharedPreferences.getInstance();
    stateS = await _prefs.getBool('theme') ?? false;
  }
  
}