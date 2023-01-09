import 'package:test_app_ui_windows/test_app_ui_windows.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Text(toString()),
      ),
    );
  }
}
