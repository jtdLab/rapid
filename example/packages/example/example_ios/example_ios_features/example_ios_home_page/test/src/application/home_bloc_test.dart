import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain_markdown/example_domain_markdown.dart';
import 'package:example_ios_home_page/src/application/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

HomeBloc _getHomeBloc([IMarkdownService? markdownService]) {
  return HomeBloc(markdownService ?? MockMarkdownService());
}

void main() {
  group('HomeBloc', () {
    test('has initial state Initial', () {
      // Arrange
      final homeBloc = _getHomeBloc();

      //  Act + Assert
      expect(homeBloc.state, const HomeState.loadInProgress());
    });

    group('Started', () {
      late IMarkdownService markdownService;

      setUp(() {
        markdownService = MockMarkdownService();
      });

      blocTest<HomeBloc, HomeState>(
        'emits LoadSuccess when fetching readme succeeds',
        setUp: () {
          when(
            () => markdownService.fetchMarkdownFile(url: any(named: 'url')),
          ).thenAnswer((_) async => right('Some markdown'));
        },
        build: () => _getHomeBloc(markdownService),
        act: (bloc) => bloc.add(const HomeEvent.started()),
        expect: () => [
          const HomeState.loadSuccess(readMe: 'Some markdown'),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits LoadFailure when fetching readme fails',
        setUp: () {
          when(
            () => markdownService.fetchMarkdownFile(url: any(named: 'url')),
          ).thenAnswer(
            (_) async => left(
              const MarkdownServiceFetchMarkdownFileFailure.notFound(),
            ),
          );
        },
        build: () => _getHomeBloc(markdownService),
        act: (bloc) => bloc.add(const HomeEvent.started()),
        expect: () => [
          const HomeState.loadFailure(
            failure: MarkdownServiceFetchMarkdownFileFailure.notFound(),
          ),
        ],
      );
    });
  });
}
