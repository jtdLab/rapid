import 'package:dartz/dartz.dart';
import 'package:example_domain_markdown/i_markdown_service.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Implementation of [IMarkdownService] using a remote data source.
@dev
@LazySingleton(as: IMarkdownService)
class RemoteMarkdownService implements IMarkdownService {
  final http.Client client;

  RemoteMarkdownService(this.client);

  @override
  Future<Either<MarkdownServiceFetchMarkdownFileFailure, String>>
      fetchMarkdownFile({
    required String url,
  }) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return right(response.body);
    } else {
      if (response.statusCode == 404) {
        return left(MarkdownServiceFetchMarkdownFileFailure.notFound());
      } else {
        return left(MarkdownServiceFetchMarkdownFileFailure.serverError());
      }
    }
  }
}
