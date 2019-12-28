import 'package:tioli/common/shared_preferences_helper.dart';

class Global {
  String _userId = "strUserId";
  String _isUserLoggedIn = "bLoggedIn";

get isLoggedIn => SharedPreferencesHelper.boolGetValue(_isUserLoggedIn);
  set isLoggedIn(bool value) =>
      SharedPreferencesHelper.boolAddKey(_isUserLoggedIn, value);

  get currentUserId async =>
      SharedPreferencesHelper.strGetValue(_userId);
  set currentUserId(String value) =>
      SharedPreferencesHelper.strAddKey(_userId, value);

  Future<bool> isUserLoggedIn() async{
    
    bool loggedIn = false;
    loggedIn = await SharedPreferencesHelper.boolGetValue(_isUserLoggedIn);
    print(loggedIn);
    return loggedIn;
  }
}
