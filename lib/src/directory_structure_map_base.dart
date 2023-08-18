import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:convert/convert.dart';

enum FileContentMode { hex, none, text }

/// Converts a directory to a map.
/// Options:
/// - [filter] - a function that can be used to filter out files and directories.
/// - [contentMode] - specifies how to handle file contents.
///   - [FileContentMode.hex] - file contents will be converted to hex strings.
///   - [FileContentMode.none] - file contents will not be included in the map.
///   - [FileContentMode.text] - file contents will be converted to text.
Future<Map<String, dynamic>> directoryToMap(String dirPath,
    {bool Function(String name, FileSystemEntity entity)? filter,
    FileContentMode? contentMode}) async {
  Map<String, dynamic> map = {};
  await _directoryToMapInternal(
      map, Directory(dirPath), filter, contentMode ?? FileContentMode.hex);
  return map;
}

Future<void> _directoryToMapInternal(
    Map<String, dynamic> map,
    Directory dir,
    bool Function(String name, FileSystemEntity entity)? filter,
    FileContentMode contentMode) async {
  var entities = await dir.list().toList();
  await Future.wait(
      entities.map((e) => _entityToMapInternal(map, e, filter, contentMode)));
}

Future<void> _entityToMapInternal(
    Map<String, dynamic> map,
    FileSystemEntity ent,
    bool Function(String name, FileSystemEntity entity)? filter,
    FileContentMode contentMode) async {
  var name = p.basename(ent.path);
  if (filter != null && !filter(name, ent)) {
    return;
  }
  if (ent is Directory) {
    map[name] = await directoryToMap(ent.path,
        filter: filter, contentMode: contentMode);
  } else if (contentMode == FileContentMode.none) {
    map[name] = null;
  } else if (contentMode == FileContentMode.text) {
    map[name] = await (ent as File).readAsString();
  } else {
    var byteString = hex.encode(await (ent as File).readAsBytes());
    map[name] = byteString;
  }
}
