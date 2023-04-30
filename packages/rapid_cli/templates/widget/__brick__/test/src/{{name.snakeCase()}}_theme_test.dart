{{^android}}{{^ios}}{{^linux}}{{^macos}}{{^web}}{{^windows}}import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/windows}}{{/web}}{{/macos}}{{/linux}}{{/ios}}{{/android}}{{#android}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_android/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/android}}{{#ios}}import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_ios/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/ios}}{{#linux}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_linux/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/linux}}{{#macos}}import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_macos/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/macos}}{{#web}}import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_web/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/web}}{{#windows}}import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}_ui_windows/src/{{name.snakeCase()}}_theme.dart';

void main() {
  group('{{project_name.pascalCase()}}{{name.pascalCase()}}Theme', () {
    group('.light', () {
      final light = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.light;

      test('.backgroundColor', () {
        // Assert
        expect(light.backgroundColor, const Color(0xFFFFFFFF));
      });
    });

    group('.dark', () {
      final dark = {{project_name.pascalCase()}}{{name.pascalCase()}}Theme.dark;

      test('.backgroundColor', () {
        // Assert
        expect(dark.backgroundColor, const Color(0xFF000000));
      });
    });
  });
}{{/windows}}
