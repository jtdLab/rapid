import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain_markdown/example_domain_markdown.dart';
import 'package:example_ios_home_page/src/application/home_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkdownService extends Mock implements IMarkdownService {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
