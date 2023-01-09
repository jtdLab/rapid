import 'package:test_app_ui_ios/test_app_ui_ios.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = TestAppColors.primary;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: Center(
        child: Text(toString()),
      ),
    );
  }
}
