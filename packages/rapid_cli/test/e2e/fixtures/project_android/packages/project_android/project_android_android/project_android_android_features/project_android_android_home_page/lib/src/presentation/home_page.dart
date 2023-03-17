import 'package:auto_route/auto_route.dart';
import 'package:project_android_android_home_page/src/presentation/l10n/l10n.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ProjectAndroidScaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}
