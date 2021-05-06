import 'package:shared_preferences/shared_preferences.dart';

saveUser(String uid) async {
  SharedPreferences.getInstance().then((value) => value.setString('uid', uid));
}

String uid = '';
