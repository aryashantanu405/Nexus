

import 'package:flutter_riverpod/legacy.dart';


class NavigationController extends StateNotifier<int>{

  NavigationController():super(0);

  void changeScreen(int screenIndex)
  {
    state = screenIndex;
  }

  void reset()
  {
    state = 0;
  }


}

final navigationControllerProvider = StateNotifierProvider<NavigationController, int>((ref) {
  return NavigationController();
});