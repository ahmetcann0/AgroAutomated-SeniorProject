import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeStateNotifier = ChangeNotifierProvider((ref) => AppThemeState());

class AppThemeState extends ChangeNotifier {
  var isDarkModeEnabled = false;

  void setLigthTheme() {
    isDarkModeEnabled = false;
    notifyListeners();
  }

  void setDarkTheme() {
    isDarkModeEnabled = true;
    notifyListeners();
  }
}
