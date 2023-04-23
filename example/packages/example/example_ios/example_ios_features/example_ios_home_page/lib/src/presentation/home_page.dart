import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_home_page/src/application/home_bloc.dart';
import 'package:example_ios_home_page/src/presentation/l10n/l10n.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class HomePage extends StatelessWidget implements AutoRouteWrapper {
  const HomePage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeEvent.started()),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => state.map(
          loadInProgress: (_) => const Center(
            child: CupertinoActivityIndicator(),
          ),
          loadSuccess: (state) => Markdown(
            data: state.readMe,
            imageBuilder: (uri, _, __) => _buildImage(context, uri: uri),
            onTapLink: (_, href, __) => href != null ? _launchUrl(href) : null,
          ),
          loadFailure: (state) => Center(
            child: state.failure.map(
              serverError: (_) => Text(context.l10n.errorServer),
              notFound: (_) => Text(context.l10n.errorNotFound),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context, {
    required Uri uri,
  }) {
    final isDark = uri.pathSegments.last.split('.').first.endsWith('_black');

    // TODO: consider getting brightness from the theme?
    final brightness = MediaQuery.of(context).platformBrightness;
    if ((!isDark && brightness == Brightness.light) ||
        (isDark && brightness == Brightness.dark)) {
      return Image.network(uri.toString());
    } else {
      return Container();
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
