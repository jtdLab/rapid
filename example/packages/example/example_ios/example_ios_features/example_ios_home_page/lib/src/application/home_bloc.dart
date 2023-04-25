import 'package:bloc/bloc.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain_markdown/example_domain_markdown.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_bloc.freezed.dart';
part 'home_event.dart';
part 'home_state.dart';

@ios
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IMarkdownService _markdownService;

  static const _readMeEndpoint =
      'https://raw.githubusercontent.com/jtdLab/rapid/main/README.md';

  HomeBloc(this._markdownService)
      : super(
          // Set initial state
          const HomeState.loadInProgress(),
        ) {
    // Register handlers
    on<_Started>(
      (event, emit) async => _handleStarted(event, emit),
    );
  }

  /// Handle incoming [_Started] event.
  Future<void> _handleStarted(
    _Started event,
    Emitter<HomeState> emit,
  ) async {
    final failureOrReadMe =
        await _markdownService.fetchMarkdownFile(url: _readMeEndpoint);

    failureOrReadMe.fold(
      (failure) => emit(HomeState.loadFailure(failure: failure)),
      (readMe) => emit(HomeState.loadSuccess(readMe: readMe)),
    );
  }
}
