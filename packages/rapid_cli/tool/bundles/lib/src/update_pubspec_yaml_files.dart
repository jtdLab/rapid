import 'dart:io';

import 'package:bundles/src/common.dart';
import 'package:path/path.dart' as p;

final RegExp _dartRegex = RegExp(r'( +)sdk: ">=\d+\.\d+\.\d+\s<\d+\.\d+\.\d+"');
final RegExp _flutterRegex = RegExp(r'( +)flutter: ">=\d+\.\d+\.\d+"');
RegExp _packageRegex(String name) =>
    RegExp(r'( +)' '$name' r': \^\d+\.\d+\.\d+');

Future<void> updatePubspecYamlFiles() async {
  for (final template in templates.whereType<PackageTemplate>()) {
    final pubspecFile = File(p.join(template.path, '__brick__/pubspec.yaml'));
    var content = pubspecFile.readAsStringSync();
    content = content.replaceAllMapped(
      _dartRegex,
      (match) {
        final spaces = match[1]!;
        return '$spaces${dart.toYaml()}';
      },
    );
    content = content.replaceAllMapped(
      _flutterRegex,
      (match) {
        final spaces = match[1]!;
        return '$spaces${flutter.toYaml()}';
      },
    );
    for (final package in packages) {
      content = content.replaceAllMapped(
        _packageRegex(package.name),
        (match) {
          final spaces = match[1]!;
          return '$spaces${package.toYaml()}';
        },
      );
    }

    pubspecFile.writeAsStringSync(content);
  }
}
