import 'package:auto_route/auto_route.dart';
import 'package:example_macos_home_page/src/presentation/l10n/l10n.dart';
import 'package:example_ui_macos/example_ui_macos.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.title;

    return ExampleScaffold(
      children: [
        ContentArea(
          builder: (context, _) {
            return Center(
              child: Text(title),
            );
          },
        ),
      ],
    );
  }
}
