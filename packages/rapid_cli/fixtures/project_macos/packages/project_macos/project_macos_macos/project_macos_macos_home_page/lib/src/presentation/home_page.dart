import 'package:project_macos_macos_home_page/src/presentation/l10n/l10n.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ProjectMacosScaffold(
      children: [
        ContentArea(
          builder: (context, controller) {
            return Center(
              child: Text(title),
            );
          },
        ),
      ],
    );
  }
}
