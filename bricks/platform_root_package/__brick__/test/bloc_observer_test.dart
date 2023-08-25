import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_{{#android}}android{{/android}}{{#ios}}ios{{/ios}}{{#linux}}linux{{/linux}}{{#macos}}macos{{/macos}}{{#web}}web{{/web}}{{#windows}}windows{{/windows}}{{#mobile}}mobile{{/mobile}}/bloc_observer.dart';
import 'package:{{project_name}}_logging/{{project_name}}_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

{{project_name.pascalCase()}}BlocObserver _get{{project_name.pascalCase()}}BlocObserver({{project_name.pascalCase()}}Logger logger) {
  return {{project_name.pascalCase()}}BlocObserver(logger);
}

void main() {
  group('{{project_name.pascalCase()}}BlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();

      // Act
      final {{project_name.camelCase()}}BlocObserver = _get{{project_name.pascalCase()}}BlocObserver(logger);

      // Act
      expect({{project_name.camelCase()}}BlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}BlocObserver = _get{{project_name.pascalCase()}}BlocObserver(logger);

      // Act
      {{project_name.camelCase()}}BlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}BlocObserver = _get{{project_name.pascalCase()}}BlocObserver(logger);

      // Act
      {{project_name.camelCase()}}BlocObserver.onEvent(MockBloc(), 88);

      // Assert
      verify(
        () => logger.debug(
          'onEvent -- MockBloc\n'
          '\n'
          '88',
        ),
      ).called(1);
    });

    test('.onChange()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}BlocObserver = _get{{project_name.pascalCase()}}BlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      {{project_name.camelCase()}}BlocObserver.onChange(MockBloc(), change);

      // Assert
      verify(
        () => logger.debug(
          'onChange -- MockBloc\n'
          '\n'
          'currentState: 88\n'
          'nextState: 888',
        ),
      ).called(1);
    });

    test('.onError()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}BlocObserver = _get{{project_name.pascalCase()}}BlocObserver(logger);

      // Act
      {{project_name.camelCase()}}BlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

      // Assert
      verify(
        () => logger.debug(
          'onError -- MockBloc\n'
          '\n'
          "Instance of 'Error'",
        ),
      ).called(1);
    });

    test('.onClose()', () {
      // Arrange
      final logger = Mock{{project_name.pascalCase()}}Logger();
      final {{project_name.camelCase()}}BlocObserver = _get{{project_name.pascalCase()}}BlocObserver(logger);

      // Act
      {{project_name.camelCase()}}BlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
