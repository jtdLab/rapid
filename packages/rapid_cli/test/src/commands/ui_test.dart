void main() {
  // TODO impl
}

/* import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/commands/runner.dart';
import 'package:test/test.dart';

void main() {
  group('uiAddWidget', () {
    test('creates widget and adds export to barrel file', () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      final barrelFile = MockBarrelFile();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => uiPackage.barrelFile).thenReturn(barrelFile);
      when(() => widget.existsAny).thenReturn(false);

      // Act
      await rapid.uiAddWidget(name: 'widget_name', theme: true);

      // Assert
      verify(() => logger.newLine()).called(1);
      verify(() => widget.generate()).called(1);
      verify(() => barrelFile.addExport('src/widget_name.dart')).called(1);
      verify(() => logger.newLine()).called(1);
      verify(() => logger.commandSuccess('Added Widget!')).called(1);
    });

    test('throws WidgetAlreadyExistsException when widget already exists',
        () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => widget.existsAny).thenReturn(true);

      // Act & Assert
      expect(
        () => rapid.uiAddWidget(name: 'widget_name', theme: false),
        throwsA(isA<WidgetAlreadyExistsException>()),
      );
    });
  });

  group('uiRemoveWidget', () {
    test('deletes widget and removes export from barrel file', () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      final barrelFile = MockBarrelFile();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => uiPackage.barrelFile).thenReturn(barrelFile);
      when(() => widget.existsAny).thenReturn(true);

      // Act
      await rapid.uiRemoveWidget(name: 'widget_name');

      // Assert
      verify(() => logger.newLine()).called(1);
      verify(() => widget.delete()).called(1);
      verify(() => barrelFile.removeExport('src/widget_name.dart')).called(1);
      verify(() => logger.newLine()).called(1);
      verify(() => logger.commandSuccess('Removed Widget!')).called(1);
    });

    test('throws WidgetNotFoundException when widget does not exist', () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => widget.existsAny).thenReturn(false);

      // Act & Assert
      expect(
        () => rapid.uiRemoveWidget(name: 'widget_name'),
        throwsA(isA<WidgetNotFoundException>()),
      );
    });
  });

  group('uiPlatformAddWidget', () {
    test('creates widget and adds export to barrel file', () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      final barrelFile = MockBarrelFile();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => uiPackage.barrelFile).thenReturn(barrelFile);
      when(() => widget.existsAny).thenReturn(false);

      // Act
      await rapid.uiPlatformAddWidget(
        Platform.android,
        name: 'widget_name',
        theme: true,
      );

      // Assert
      verify(() => logger.newLine()).called(1);
      verify(() => uiPackage.themedWidget(name: 'widget_name')).called(1);
      verify(() => uiPackage.widget(name: 'widget_name')).called(0);
      verify(() => widget.generate()).called(1);
      verify(() => barrelFile.addExport('src/widget_name.dart')).called(1);
      verify(() => logger.newLine()).called(1);
      verify(() => logger.commandSuccess('Added Widget!')).called(1);
    });

    test('throws WidgetAlreadyExistsException when widget already exists',
        () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => widget.existsAny).thenReturn(true);

      // Act & Assert
      expect(
        () => rapid.uiPlatformAddWidget(name: 'widget_name', theme: false),
        throwsA(isA<WidgetAlreadyExistsException>()),
      );
    });
  });

  group('uiPlatformRemoveWidget', () {
    test('deletes widget and removes export from barrel file', () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      final barrelFile = MockBarrelFile();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => uiPackage.barrelFile).thenReturn(barrelFile);
      when(() => widget.existsAny).thenReturn(true);

      // Act
      await rapid.uiPlatformRemoveWidget(
        Platform.ios,
        name: 'widget_name',
      );

      // Assert
      verify(() => logger.newLine()).called(1);
      verify(() => uiPackage.themedWidget(name: 'widget_name')).called(1);
      verify(() => uiPackage.widget(name: 'widget_name')).called(0);
      verify(() => widget.delete()).called(1);
      verify(() => barrelFile.removeExport('src/widget_name.dart')).called(1);
      verify(() => logger.newLine()).called(1);
      verify(() => logger.commandSuccess('Removed Widget!')).called(1);
    });

    test('throws WidgetNotFoundException when widget does not exist', () async {
      // Arrange
      final uiPackage = MockUiPackage();
      final widget = MockWidget();
      when(() => rapid.project.uiModule.uiPackage).thenReturn(uiPackage);
      when(() => uiPackage.themedWidget(name: any(named: 'name')))
          .thenReturn(widget);
      when(() => uiPackage.widget(name: any(named: 'name'))).thenReturn(widget);
      when(() => widget.existsAny).thenReturn(false);

      // Act & Assert
      expect(
        () => rapid.uiPlatformRemoveWidget(name: 'widget_name'),
        throwsA(isA<WidgetNotFoundException>()),
      );
    });
  });
}
 */
