import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:mocktail/mocktail.dart';

class MockBloc extends Mock implements Bloc {}

class MockChange extends Mock implements Change {}

abstract class _Function {
  Future<void> call();
}

class MockFunction extends Mock implements _Function {
  MockFunction() {
    when(() => call()).thenAnswer((_) async {});
  }
}

class Mock{{project_name.pascalCase()}}Logger extends Mock implements {{project_name.pascalCase()}}Logger {
  Mock{{project_name.pascalCase()}}Logger() {
    when(() => debug(any())).thenReturn(null);
  }
}

class MockRoute extends Mock implements Route {}

class MockRouteSettings extends Mock implements RouteSettings {}

class MockTabPageRoute extends Mock implements TabPageRoute {}
