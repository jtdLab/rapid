import 'package:propertylistserialization/propertylistserialization.dart';
import 'package:rapid_cli/src/core/plist_file.dart';
import 'package:xml/xml.dart' show XmlDocument;

import 'file_impl.dart';

class PlistFileImpl extends FileImpl implements PlistFile {
  PlistFileImpl({
    super.path,
    required String super.name,
  }) : super(extension: 'plist');

  @override
  Map<String, Object> readDict() {
    final contents = read();

    final plist = PropertyListSerialization.propertyListWithString(contents);

    if (PropertyListSerialization.propertyListWithString(contents)
        is! Map<String, Object>) {
      throw PlistRootIsNotDict();
    }

    return plist as Map<String, Object>;
  }

  @override
  void setDict(Map<String, Object> map) {
    final contents = read();

    if (PropertyListSerialization.propertyListWithString(contents)
        is! Map<String, Object>) {
      throw PlistRootIsNotDict();
    }

    final output = PropertyListSerialization.stringWithPropertyList(map);
    write(XmlDocument.parse(output).toXmlString(pretty: true));
  }
}
