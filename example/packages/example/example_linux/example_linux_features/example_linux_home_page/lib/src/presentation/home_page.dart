import 'package:auto_route/auto_route.dart';
import 'package:example_linux_home_page/src/presentation/l10n/l10n.dart';
import 'package:example_ui_linux/example_ui_linux.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ExampleScaffold(
      body: Center(
        child: Text(title),
      ),
    );
  }
}