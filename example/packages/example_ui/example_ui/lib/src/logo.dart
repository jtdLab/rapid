import 'dart:ui';

import 'package:example_ui/src/assets.gen.dart';
import 'package:flutter/widgets.dart';

class RapidLogo extends StatelessWidget {
  final double width;
  final double height;

  const RapidLogo({super.key})
      : width = 175,
        height = 175;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Builder(
        builder: (context) {
          final brightness = MediaQuery.of(context).platformBrightness;

          if (brightness == Brightness.light) {
            return Assets.images.logo.svg(package: 'example_ui');
          } else {
            return Assets.images.logoDark.svg(package: 'example_ui');
          }
        },
      ),
    );
  }
}
