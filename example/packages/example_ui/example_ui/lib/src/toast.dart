import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget exampleToastBuilder(BuildContext context, Widget child) =>
    FToastBuilder()(context, child);

mixin ExampleToastMixin<T extends StatefulWidget> on State<T> {
  late final FToast _fToast;

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
  }

  void showToast(
    String msg, {
    double fontSize = 16,
  }) {
    _fToast.showToast(
      child: ExampleToast(msg: msg, fontSize: fontSize),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}

class ExampleToast extends StatelessWidget {
  final String msg;
  final double fontSize;

  const ExampleToast({
    super.key,
    required this.msg,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color.fromARGB(255, 255, 59, 48),
      ),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
