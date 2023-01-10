import 'package:project_all_ui_web/project_all_ui_web.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = ProjectAllColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(toString()),
      ),
    );
  }
}
