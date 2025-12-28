import 'package:flutter_riverpod/flutter_riverpod.dart';



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