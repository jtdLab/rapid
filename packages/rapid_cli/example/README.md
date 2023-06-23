# Activate Rapid CLI

```sh
# rapid requires melos >=3.0.0
flutter pub global activate melos
```

```sh
# required to generated clean coverage reports
flutter pub global activate test_cov_console
flutter pub global activate remove_from_coverage
```

```sh
flutter pub global activate -sgit https://github.com/jtdLab/rapid.git --git-path packages/rapid_cli/
```

# See list of available commands

```sh
rapid --help
```
