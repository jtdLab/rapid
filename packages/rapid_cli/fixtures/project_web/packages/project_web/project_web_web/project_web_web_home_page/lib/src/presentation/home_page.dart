import 'package:project_web_ui_web/project_web_ui_web.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = ProjectWebColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(toString()),
      ),
    );
  }
}
