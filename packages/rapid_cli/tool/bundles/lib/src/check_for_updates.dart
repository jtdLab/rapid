import 'dart:convert';

import 'package:html/parser.dart' as htmlParser;

import 'common.dart';
import 'http.dart';

const _dartEndpoint =
    'https://storage.googleapis.com/dart-archive/channels/stable/release/latest/VERSION';

const _flutterEndpoint = 'https://docs.flutter.dev/release/release-notes';

String _packageEndpoint(String packageName) =>
    'https://pub.dev/api/packages/$packageName';

var _versionRegex = RegExp(r'\d+\.\d+\.\d+');

Future<void> checkForUpdates({
  required String currentDartVersion,
  required String currentFlutterVersion,
  required List<PackageDependency> packages,
}) async {
  await _checkForSdkUpdates(
    'Dart',
    currentVersion: currentDartVersion,
    endpoint: _dartEndpoint,
    responseHandler: (response) {
      final json = jsonDecode(response);
      return json['version'];
    },
  );
  await _checkForSdkUpdates(
    'Flutter',
    currentVersion: currentFlutterVersion,
    endpoint: _flutterEndpoint,
    responseHandler: (response) {
      final document = htmlParser.parse(response);
      final ulElements = document.querySelectorAll('ul');
      final filteredUlElements = ulElements.where((ul) {
        var liElements = ul.querySelectorAll('li');
        return liElements.any((li) => _versionRegex.hasMatch(li.text));
      });
      return filteredUlElements.first.text
          .trim()
          .replaceAll('\n', '')
          .split(' ')
          .first;
    },
  );
  await _checkForPackageUpdates(packages);
}

Future<void> _checkForSdkUpdates(
  String name, {
  required String currentVersion,
  required String endpoint,
  required String Function(String) responseHandler,
}) async {
  print('Checking for $name updates...');
  final response = await get(Uri.parse(endpoint));
  if (response.statusCode == 200) {
    final latestVersion = responseHandler(response.body);
    if (currentVersion != latestVersion) {
      print('New $name version available!');
      print('$currentVersion ($latestVersion available)');
    } else {
      print('$name is up to date.');
    }
  } else {
    throw Exception('Failed to fetch latest version of $name.');
  }
}

Future<void> _checkForPackageUpdates(List<PackageDependency> packages) async {
  print('Check for new package updates:');
  final updatablePackages = <String>[];
  for (final package in packages) {
    final result = await _checkForPackageUpdate(package);
    if (result != null) {
      updatablePackages.add(
        '${result['name']} ${result['currentVersion']} (${result['latestVersion']} available)',
      );
    }
  }

  if (updatablePackages.isNotEmpty) {
    for (final package in updatablePackages) {
      print(package);
    }
  } else {
    print('All packages are up to date.');
  }
}

Future<Map<String, dynamic>?> _checkForPackageUpdate(
  PackageDependency package,
) async {
  final name = package.name;
  final currentVersion = package.version;
  final response = await get(Uri.parse(_packageEndpoint(name)));
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final latestVersion = responseData['latest']['version'];
    if (currentVersion != latestVersion) {
      return {
        'name': name,
        'currentVersion': currentVersion,
        'latestVersion': latestVersion,
      };
    }
    return null;
  } else {
    throw Exception('Failed to fetch latest version of $name.');
  }
}
