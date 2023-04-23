import 'package:auto_route/auto_route.dart';
import 'package:example_di/example_di.dart';
import 'package:example_ios_home_page/src/application/home_bloc.dart';
import 'package:example_ios_home_page/src/presentation/l10n/l10n.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
          loadSuccess: (state) => Markdown(data: state.readMe),
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
}
