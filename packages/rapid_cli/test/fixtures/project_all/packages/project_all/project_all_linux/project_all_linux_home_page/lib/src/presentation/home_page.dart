import 'package:project_all_ui_linux/project_all_ui_linux.dart';

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
