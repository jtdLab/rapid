import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = ProjectLinuxColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(toString()),
      ),
    );
  }
}
