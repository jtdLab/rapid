import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'i_markdown_service.freezed.dart';

// Service to work with markdown files.
abstract class IMarkdownService {
  Future<Either<MarkdownServiceFetchMarkdownFileFailure, String>>
      fetchMarkdownFile({
    required String url,
  });
}

/// Failure union that belongs to [IMarkdownService.fetchMarkdownFile].
@freezed
class MarkdownServiceFetchMarkdownFileFailure
    with _$MarkdownServiceFetchMarkdownFileFailure {
  const factory MarkdownServiceFetchMarkdownFileFailure.serverError() =
      _FetchMarkdownFileServerError;
  const factory MarkdownServiceFetchMarkdownFileFailure.notFound() =
      _FetchMarkdownFileNotFound;
}
