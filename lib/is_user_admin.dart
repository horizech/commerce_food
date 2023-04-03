import 'package:apiraiser/apiraiser.dart';

bool isUserAdmin() {
  User? user = Apiraiser.authentication.getCurrentUser();
  if (user != null &&
      user.roleIds != null &&
      (user.roleIds!.contains(2) || user.roleIds!.contains(1))) {
    return true;
  } else {
    return false;
  }
}
