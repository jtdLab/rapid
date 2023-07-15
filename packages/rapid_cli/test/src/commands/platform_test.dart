void main() {
  // TODO impl
}

/* import 'package:test/test.dart';

void main() {
  group('platformAddFeatureFlow', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeatureFlow(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
          navigator: true,
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeatureFlow(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
          navigator: true,
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test('completes', () async {
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformAddFeatureFlow(
        Platform.iOS,
        name: 'Feature',
        description: 'Feature description',
        navigator: true,
      );

      verify(() => logger.newLine()).called(1);
      verify(() => featurePackage.generate(description: 'Feature description'))
          .called(1);
      verify(() => rootPackage.registerFeaturePackage(featurePackage))
          .called(1);
      verify(() => _addNavigator(
          featurePackage: featurePackage,
          navigationPackage: navigationPackage)).called(1);
      // Add more verification as needed
    });
  });

  group('platformAddFeatureTabFlow', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
          navigator: true,
          subFeatures: {'SubFeature1', 'SubFeature2'},
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeatureTabFlow(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
          navigator: true,
          subFeatures: {'SubFeature1', 'SubFeature2'},
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test('completes', () async {
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformAddFeatureTabFlow(
        Platform.iOS,
        name: 'Feature',
        description: 'Feature description',
        navigator: true,
        subFeatures: {'SubFeature1', 'SubFeature2'},
      );

      verify(() => logger.newLine()).called(1);
      verify(() => featurePackage.generate(
          description: 'Feature description',
          subFeatures: {'SubFeature1', 'SubFeature2'})).called(1);
      verify(() => rootPackage.registerFeaturePackage(featurePackage))
          .called(1);
      verify(() => _addNavigator(
          featurePackage: featurePackage,
          navigationPackage: navigationPackage)).called(1);
      // Add more verification as needed
    });
  });

  group('platformAddFeaturePage', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeaturePage(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
          navigator: true,
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeaturePage(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
          navigator: true,
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test('completes', () async {
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformAddFeaturePage(
        Platform.iOS,
        name: 'Feature',
        description: 'Feature description',
        navigator: true,
      );

      verify(() => logger.newLine()).called(1);
      verify(() => featurePackage.generate(description: 'Feature description'))
          .called(1);
      verify(() => rootPackage.registerFeaturePackage(featurePackage))
          .called(1);
      verify(() => _addNavigator(
          featurePackage: featurePackage,
          navigationPackage: navigationPackage)).called(1);
      // Add more verification as needed
    });
  });

  group('platformAddFeatureWidget', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeatureWidget(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureAlreadyExistsException when feature package already exists',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddFeatureWidget(
          Platform.iOS,
          name: 'Feature',
          description: 'Feature description',
        ),
        throwsA(isA<FeatureAlreadyExistsException>()),
      );
    });

    test('completes', () async {
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformAddFeatureWidget(
        Platform.iOS,
        name: 'Feature',
        description: 'Feature description',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => featurePackage.generate(description: 'Feature description'))
          .called(1);
      verify(() => rootPackage.registerFeaturePackage(featurePackage))
          .called(1);
      // Add more verification as needed
    });
  });

  group('platformAddLanguage', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddLanguage(
          Platform.iOS,
          language: Language('fr'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws LanguageAlreadyPresentException when language is already present',
        () async {
      when(() => localizationPackage.supportedLanguages())
          .thenReturn(['en', 'fr']);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddLanguage(
          Platform.iOS,
          language: Language('fr'),
        ),
        throwsA(isA<LanguageAlreadyPresentException>()),
      );
    });

    test('completes', () async {
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformAddLanguage(
        Platform.iOS,
        language: Language('fr'),
      );

      verify(() => logger.newLine()).called(1);
      verify(() => localizationPackage.addLanguage(Language('fr'))).called(1);
      // Add more verification as needed
    });
  });

  group('platformAddNavigator', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddNavigator(
          Platform.iOS,
          featureName: 'Feature',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureNotRoutableException when feature package is not routable',
        () async {
      final nonRoutableFeaturePackage = MockFeaturePackage();

      when(() => nonRoutableFeaturePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddNavigator(
          Platform.iOS,
          featureName: 'Feature',
        ),
        throwsA(isA<FeatureNotRoutableException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformAddNavigator(
          Platform.iOS,
          featureName: 'Feature',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('completes', () async {
      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformAddNavigator(
        Platform.iOS,
        featureName: 'Feature',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => _addNavigator(
          featurePackage: featurePackage,
          navigationPackage: navigationPackage)).called(1);
      // Add more verification as needed
    });
  });

  group('platformFeatureAddBloc', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureAddBloc(
          Platform.iOS,
          name: 'Bloc',
          featureName: 'Feature',
          outputDir: 'output/dir',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureAddBloc(
          Platform.iOS,
          name: 'Bloc',
          featureName: 'Feature',
          outputDir: 'output/dir',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws BlocAlreadyExistsException when bloc already exists',
        () async {
      final bloc = MockBloc();

      when(() => bloc.existsAny).thenReturn(true);
      when(() => featurePackage.bloc(name: any())).thenReturn(bloc);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureAddBloc(
          Platform.iOS,
          name: 'Bloc',
          featureName: 'Feature',
          outputDir: 'output/dir',
        ),
        throwsA(isA<BlocAlreadyExistsException>()),
      );
    });

    test('completes', () async {
      final bloc = MockBloc();

      when(() => bloc.existsAny).thenReturn(false);
      when(() => featurePackage.bloc(name: any())).thenReturn(bloc);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformFeatureAddBloc(
        Platform.iOS,
        name: 'Bloc',
        featureName: 'Feature',
        outputDir: 'output/dir',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => bloc.generate()).called(1);
      // Add more verification as needed
    });
  });

  group('platformFeatureAddCubit', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureAddCubit(
          Platform.iOS,
          name: 'Cubit',
          featureName: 'Feature',
          outputDir: 'output/dir',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureAddCubit(
          Platform.iOS,
          name: 'Cubit',
          featureName: 'Feature',
          outputDir: 'output/dir',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws CubitAlreadyExistsException when cubit already exists',
        () async {
      final cubit = MockCubit();

      when(() => cubit.existsAny).thenReturn(true);
      when(() => featurePackage.cubit(name: any())).thenReturn(cubit);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureAddCubit(
          Platform.iOS,
          name: 'Cubit',
          featureName: 'Feature',
          outputDir: 'output/dir',
        ),
        throwsA(isA<CubitAlreadyExistsException>()),
      );
    });

    test('completes', () async {
      final cubit = MockCubit();

      when(() => cubit.existsAny).thenReturn(false);
      when(() => featurePackage.cubit(name: any())).thenReturn(cubit);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformFeatureAddCubit(
        Platform.iOS,
        name: 'Cubit',
        featureName: 'Feature',
        outputDir: 'output/dir',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => cubit.generate()).called(1);
      // Add more verification as needed
    });
  });

  group('platformFeatureRemoveBloc', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          Platform.iOS,
          name: 'Bloc',
          featureName: 'Feature',
          dir: 'directory',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          Platform.iOS,
          name: 'Bloc',
          featureName: 'Feature',
          dir: 'directory',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws BlocNotFoundException when bloc is not found', () async {
      final bloc = MockBloc();

      when(() => bloc.existsAny).thenReturn(false);
      when(() => featurePackage.bloc(name: any())).thenReturn(bloc);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureRemoveBloc(
          Platform.iOS,
          name: 'Bloc',
          featureName: 'Feature',
          dir: 'directory',
        ),
        throwsA(isA<BlocNotFoundException>()),
      );
    });

    test('completes', () async {
      final bloc = MockBloc();

      when(() => bloc.existsAny).thenReturn(true);
      when(() => featurePackage.bloc(name: any())).thenReturn(bloc);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformFeatureRemoveBloc(
        Platform.iOS,
        name: 'Bloc',
        featureName: 'Feature',
        dir: 'directory',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => bloc.delete()).called(1);
      // Add more verification as needed
    });
  });

  group('platformFeatureRemoveCubit', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          Platform.iOS,
          name: 'Cubit',
          featureName: 'Feature',
          dir: 'directory',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          Platform.iOS,
          name: 'Cubit',
          featureName: 'Feature',
          dir: 'directory',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('throws CubitNotFoundException when cubit is not found', () async {
      final cubit = MockCubit();

      when(() => cubit.existsAny).thenReturn(false);
      when(() => featurePackage.cubit(name: any())).thenReturn(cubit);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformFeatureRemoveCubit(
          Platform.iOS,
          name: 'Cubit',
          featureName: 'Feature',
          dir: 'directory',
        ),
        throwsA(isA<CubitNotFoundException>()),
      );
    });

    test('completes', () async {
      final cubit = MockCubit();

      when(() => cubit.existsAny).thenReturn(true);
      when(() => featurePackage.cubit(name: any())).thenReturn(cubit);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformFeatureRemoveCubit(
        Platform.iOS,
        name: 'Cubit',
        featureName: 'Feature',
        dir: 'directory',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => cubit.delete()).called(1);
      // Add more verification as needed
    });
  });

  group('platformRemoveFeature', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveFeature(
          Platform.iOS,
          name: 'Feature',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveFeature(
          Platform.iOS,
          name: 'Feature',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('completes', () async {
      final remainingFeaturePackages = [MockFeaturePackage()];
      final rootPackage = MockRootPackage();

      when(() => featurePackage.existsSync()).thenReturn(true);
      when(() => featuresDirectory.featurePackages())
          .thenReturn(remainingFeaturePackages);
      when(() => platformDirectory.rootPackage).thenReturn(rootPackage);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformRemoveFeature(
        Platform.iOS,
        name: 'Feature',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => rootPackage.unregisterFeaturePackage(featurePackage))
          .called(1);
      verifyInOrder([
        ...remainingFeaturePackages.map((fp) => fp.pubSpecFile),
        if (featurePackage is PlatformRoutableFeaturePackage)
          featurePackage.navigatorImplementation,
      ]);
      // Add more verification as needed
    });
  });

  group('platformRemoveLanguage', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveLanguage(
          Platform.iOS,
          language: Language('en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws LanguageNotFoundException when language is not found',
        () async {
      final supportedLanguages = [Language('en'), Language('fr')];

      when(() => localizationPackage.supportedLanguages())
          .thenReturn(supportedLanguages);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveLanguage(
          Platform.iOS,
          language: Language('de'),
        ),
        throwsA(isA<LanguageNotFoundException>()),
      );
    });

    test(
        'throws CantRemoveDefaultLanguageException when removing default language',
        () async {
      final supportedLanguages = [Language('en'), Language('fr')];

      when(() => localizationPackage.supportedLanguages())
          .thenReturn(supportedLanguages);
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language('en'));

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveLanguage(
          Platform.iOS,
          language: Language('en'),
        ),
        throwsA(isA<CantRemoveDefaultLanguageException>()),
      );
    });

    test('completes', () async {
      final supportedLanguages = [Language('en'), Language('fr')];
      final rootPackage = MockRootPackage();

      when(() => localizationPackage.supportedLanguages())
          .thenReturn(supportedLanguages);
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language('fr'));
      when(() => platformDirectory.rootPackage).thenReturn(rootPackage);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformRemoveLanguage(
        Platform.iOS,
        language: Language('en'),
      );

      verify(() => logger.newLine()).called(1);
      verifyInOrder([
        ...supportedLanguages,
        if (rootPackage is IosRootPackage) rootPackage,
        if (rootPackage is MobileRootPackage) rootPackage,
      ]);
      // Add more verification as needed
    });
  });

  group('platformRemoveNavigator', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveNavigator(
          Platform.iOS,
          featureName: 'Feature',
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test(
        'throws FeatureNotRoutableException when feature package is not routable',
        () async {
      final featurePackage = MockFeaturePackage();

      when(() => featurePackage is PlatformRoutableFeaturePackage)
          .thenReturn(false);
      when(() => featurePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveNavigator(
          Platform.iOS,
          featureName: 'Feature',
        ),
        throwsA(isA<FeatureNotRoutableException>()),
      );
    });

    test('throws FeatureNotFoundException when feature package is not found',
        () async {
      final featurePackage = MockFeaturePackage();

      when(() => featurePackage is PlatformRoutableFeaturePackage)
          .thenReturn(true);
      when(() => featurePackage.existsSync()).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformRemoveNavigator(
          Platform.iOS,
          featureName: 'Feature',
        ),
        throwsA(isA<FeatureNotFoundException>()),
      );
    });

    test('completes', () async {
      final featurePackage = MockFeaturePackage();

      when(() => featurePackage is PlatformRoutableFeaturePackage)
          .thenReturn(true);
      when(() => featurePackage.existsSync()).thenReturn(true);

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformRemoveNavigator(
        Platform.iOS,
        featureName: 'Feature',
      );

      verify(() => logger.newLine()).called(1);
      verify(() => _removeNavigatorInterface(
            featurePackage: featurePackage,
            navigationPackage: any(named: 'navigationPackage'),
          )).called(1);
      verify(() => _removeNavigatorImplementation(
            featurePackage: featurePackage,
          )).called(1);
      // Add more verification as needed
    });
  });

  group('platformSetDefaultLanguage', () {
    test('throws PlatformNotActivatedException when platform is not activated',
        () async {
      when(() => project.platformIsActivated(any())).thenReturn(false);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformSetDefaultLanguage(
          Platform.iOS,
          language: Language('en'),
        ),
        throwsA(isA<PlatformNotActivatedException>()),
      );
    });

    test('throws LanguageNotFoundException when language is not found',
        () async {
      final supportedLanguages = [Language('en'), Language('fr')];

      when(() => localizationPackage.supportedLanguages())
          .thenReturn(supportedLanguages);

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformSetDefaultLanguage(
          Platform.iOS,
          language: Language('de'),
        ),
        throwsA(isA<LanguageNotFoundException>()),
      );
    });

    test(
        'throws LanguageIsAlreadyDefaultLanguageException when language is already default',
        () async {
      final supportedLanguages = [Language('en'), Language('fr')];

      when(() => localizationPackage.supportedLanguages())
          .thenReturn(supportedLanguages);
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language('en'));

      final rapid = getRapid(tool: tool, logger: logger);

      expect(
        () => rapid.platformSetDefaultLanguage(
          Platform.iOS,
          language: Language('en'),
        ),
        throwsA(isA<LanguageIsAlreadyDefaultLanguageException>()),
      );
    });

    test('completes', () async {
      final supportedLanguages = [Language('en'), Language('fr')];

      when(() => localizationPackage.supportedLanguages())
          .thenReturn(supportedLanguages);
      when(() => localizationPackage.defaultLanguage())
          .thenReturn(Language('fr'));

      final rapid = getRapid(tool: tool, logger: logger);

      await rapid.platformSetDefaultLanguage(
        Platform.iOS,
        language: Language('en'),
      );

      verify(() => logger.newLine()).called(1);
      verify(() => localizationPackage.setDefaultLanguage(Language('en')))
          .called(1);
      // Add more verification as needed
    });
  });
}
 */
