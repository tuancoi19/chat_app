import 'package:fluttertoast/fluttertoast.dart';

showStatusToast(String msg) {
  return Fluttertoast.showToast(
      msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
}
