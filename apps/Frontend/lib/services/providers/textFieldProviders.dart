import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';



final passwordProvider = StateNotifierProvider<PasswordNotifier, bool>((ref){
  return PasswordNotifier();
});

class PasswordNotifier extends StateNotifier<bool>{
  PasswordNotifier() : super(false);

  void changePasswordState(bool value)
{
  state = value;
}
}