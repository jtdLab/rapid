// TODO rm this

import 'dart:io';

bool dirExists(String dir) => Directory(dir).existsSync();

bool fileExists(String file) => File(file).existsSync();
