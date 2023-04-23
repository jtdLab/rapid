import 'package:example_domain_markdown/example_domain_markdown.dart';
import 'package:example_infrastructure_markdown/src/remote_markdown_service.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

RemoteMarkdownService _remoteMarkdownService([http.Client? client]) {
  return RemoteMarkdownService(client ?? MockHttpClient());
}

void main() {
  group('RemoteMarkdownService', () {
    setUpAll(() {
      registerFallbackValue(Uri());
    });

    test('.()', () {
      // Act
      final client = MockHttpClient();
      final remoteMarkdownService = _remoteMarkdownService(client);

      // Assert
      expect(remoteMarkdownService, isNotNull);
      expect(remoteMarkdownService.client, client);
    });

    group('.fetchMarkdownFile()', () {
      test('returns the markdown file', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('Some body');
        final client = MockHttpClient();
        when(() => client.get(any())).thenAnswer((_) async => response);
        final remoteMarkdownService = _remoteMarkdownService(client);

        final failureOrString = await remoteMarkdownService.fetchMarkdownFile(
          url: 'https://www.foo.com',
        );

        expect(failureOrString, Right('Some body'));
      });

      test('returns NotFound', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(404);
        final client = MockHttpClient();
        when(() => client.get(any())).thenAnswer((_) async => response);
        final remoteMarkdownService = _remoteMarkdownService(client);

        final failureOrString = await remoteMarkdownService.fetchMarkdownFile(
          url: 'https://www.foo.com',
        );

        expect(
          failureOrString,
          Left(MarkdownServiceFetchMarkdownFileFailure.notFound()),
        );
      });

      test('returns ServerError', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(500);
        final client = MockHttpClient();
        when(() => client.get(any())).thenAnswer((_) async => response);
        final remoteMarkdownService = _remoteMarkdownService(client);

        final failureOrString = await remoteMarkdownService.fetchMarkdownFile(
          url: 'https://www.foo.com',
        );

        expect(
          failureOrString,
          Left(MarkdownServiceFetchMarkdownFileFailure.serverError()),
        );
      });
    });
  });
}
