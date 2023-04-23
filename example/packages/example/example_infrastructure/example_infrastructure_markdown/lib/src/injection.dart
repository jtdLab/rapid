import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Setup injectable package which generates dependency injection code.
///
/// For more info see: https://pub.dev/packages/injectable
@InjectableInit.microPackage()
initMicroPackage() {}

@module
abstract class RegisterModule {
  http.Client get client => http.Client();
}
