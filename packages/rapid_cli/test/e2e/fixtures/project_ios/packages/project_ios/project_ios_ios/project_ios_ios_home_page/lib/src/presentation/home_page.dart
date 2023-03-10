import 'package:project_ios_ios_home_page/src/presentation/l10n/l10n.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ProjectIosScaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
