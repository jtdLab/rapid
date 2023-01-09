import 'package:project_all_ui_ios/project_all_ui_ios.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = ProjectAllColors.primary;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: Center(
        child: Text(toString()),
      ),
    );
  }
}
