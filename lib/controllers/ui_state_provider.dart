import 'package:flutter/material.dart';

class UIStateProvider extends ChangeNotifier {
  bool _isObscured = true;
  bool currentVisibility() {
    return _isObscured;
  }
  void toggleVisibility() {
    _isObscured = !_isObscured;
    notifyListeners();
  }

  bool _isGrid = true;
  bool get isGrid => _isGrid;
  void toggleGrid() {
    _isGrid = !_isGrid;
    notifyListeners();
  }

}
