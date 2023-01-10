import 'package:project_all_ui_macos/project_all_ui_macos.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = ProjectAllColors.primary;

    return PlatformMenuBar(
      menus: const [],
      child: MacosWindow(
        backgroundColor: backgroundColor,
        child: MacosScaffold(
          backgroundColor: backgroundColor,
          children: [
            ContentArea(
              builder: (context, controller) {
                return Center(
                  child: Text(toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
