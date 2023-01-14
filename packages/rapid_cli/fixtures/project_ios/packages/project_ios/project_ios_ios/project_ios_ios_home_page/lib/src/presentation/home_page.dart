import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = ProjectIosColors.primary;

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      child: Center(
        child: Text(toString()),
      ),
    );
  }
}
