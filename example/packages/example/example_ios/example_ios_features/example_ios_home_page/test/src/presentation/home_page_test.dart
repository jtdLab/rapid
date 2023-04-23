import 'package:bloc_test/bloc_test.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain_markdown/example_domain_markdown.dart';

import 'package:example_ios_home_page/src/application/application.dart';
import 'package:example_ios_home_page/src/presentation/presentation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';
import 'helpers/helpers.dart';

extension on WidgetTester {
  Future<void> setup() async {
    // set screen size to common phone size
    await binding.setSurfaceSize(const Size(414.0, 896.0));
    // scale down font size to remove overflow errors caused by Ahem
    binding.platformDispatcher.textScaleFactorTestValue = 0.8;
  }
}

Widget _homePage(HomeBloc homeBloc) {
  return BlocProvider(
    create: (_) => homeBloc,
    child: const HomePage(),
  );
}

Widget _homePageWrapped() {
  return Builder(
    builder: (context) => const HomePage().wrappedRoute(context),
  );
}

void main() {
  group('HomePage', () {
    tearDown(() async {
      await getIt.reset();
    });

    testWidgets('injects HomeBloc', (tester) async {
      await tester.setup();

      final homeBloc = MockHomeBloc();
      whenListen(
        homeBloc,
        const Stream<HomeState>.empty(),
        initialState: const HomeState.loadInProgress(),
      );
      getIt.registerSingleton<HomeBloc>(homeBloc);
      await tester.pumpAppWidget(
        widget: _homePageWrapped(),
      );
      final context = tester.element(find.byType(HomePage));
      expect(context.read<HomeBloc>(), homeBloc);
    });

    group('renders correctly', () {
      testWidgets('when [LoadInProgress]', (tester) async {
        await tester.setup();

        final homeBloc = MockHomeBloc();
        whenListen(
          homeBloc,
          const Stream<HomeState>.empty(),
          initialState: const HomeState.loadInProgress(),
        );

        await tester.pumpAppWidget(
          widget: _homePage(homeBloc),
        );
        final scaffold = find.byType(ExampleScaffold);
        expect(scaffold, findsOneWidget);
        expect(
          find.descendant(of: scaffold, matching: find.byType(Container)),
          findsOneWidget,
        );
      });

      testWidgets('when [LoadSuccess]', (tester) async {
        await tester.setup();

        final homeBloc = MockHomeBloc();
        whenListen(
          homeBloc,
          const Stream<HomeState>.empty(),
          initialState: const HomeState.loadSuccess(readMe: 'Some markdown'),
        );

        await tester.pumpAppWidget(
          widget: _homePage(homeBloc),
        );
        final scaffoldFinder = find.byType(ExampleScaffold);
        expect(scaffoldFinder, findsOneWidget);
        final markdownFinder = find.byType(Markdown);
        expect(
          find.descendant(of: scaffoldFinder, matching: markdownFinder),
          findsOneWidget,
        );
        final markdown = tester.widget<Markdown>(markdownFinder);
        expect(markdown.data, 'Some markdown');
      });

      group('when [LoadFailure]', () {
        Future<void> performTest(
          WidgetTester tester, {
          required Locale locale,
          required MarkdownServiceFetchMarkdownFileFailure failure,
          required String expectedMessage,
        }) async {
          await tester.setup();

          final homeBloc = MockHomeBloc();
          whenListen(
            homeBloc,
            const Stream<HomeState>.empty(),
            initialState: HomeState.loadFailure(failure: failure),
          );

          await tester.pumpAppWidget(
            widget: _homePage(homeBloc),
          );
          final scaffoldFinder = find.byType(ExampleScaffold);
          expect(scaffoldFinder, findsOneWidget);
          final centerFinder = find.byType(Center);
          expect(
            find.descendant(of: scaffoldFinder, matching: centerFinder),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: centerFinder,
              matching: find.text(expectedMessage),
            ),
            findsOneWidget,
          );
        }

        group('with server error', () {
          testWidgets(
            '(en)',
            (tester) => performTest(
              tester,
              locale: const Locale('en'),
              failure:
                  const MarkdownServiceFetchMarkdownFileFailure.serverError(),
              expectedMessage: 'Server error. Try again later.',
            ),
          );
        });

        group('with not found', () {
          testWidgets(
            '(en)',
            (tester) => performTest(
              tester,
              locale: const Locale('en'),
              failure: const MarkdownServiceFetchMarkdownFileFailure.notFound(),
              expectedMessage: 'Resource not found.',
            ),
          );
        });
      });
    });
  });
}
