import 'package:auto_route/auto_route.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

@RoutePage()
class PublicRouterPage extends StatelessWidget {
  const PublicRouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoTabsRouter.pageView(
      routes: [
        LoginRoute(),
        SignUpRoute(),
      ],
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}
