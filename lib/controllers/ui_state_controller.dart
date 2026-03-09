import 'package:get/get.dart';

class UIStateController extends GetxController {
  RxBool _isObscured = true.obs;

  bool get isObscured => _isObscured.value;

  void toggleVisibility() {
    _isObscured.value = !_isObscured.value;
  }

  RxBool _isGrid = true.obs;

  bool get isGrid => _isGrid.value;

  void toggleGrid() {
    _isGrid.value = !_isGrid.value;
  }
}
