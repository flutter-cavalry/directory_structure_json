import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:convert/convert.dart';

Future<Map<String, dynamic>> directoryToMap(String dirPath,
    {bool Function(String name, FileSystemEntity entity)? filter,
    bool? noFileContents}) async {
  Map<String, dynamic> map = {};
  await _directoryToMapInternal(
      map, Directory(dirPath), filter, noFileContents ?? false);
  return map;
}

Future<void> _directoryToMapInternal(
    Map<String, dynamic> map,
    Directory dir,
    bool Function(String name, FileSystemEntity entity)? filter,
    bool noFileContents) async {
  var entities = await dir.list().toList();
  await Future.wait(entities
      .map((e) => _entityToMapInternal(map, e, filter, noFileContents)));
}

Future<void> _entityToMapInternal(
    Map<String, dynamic> map,
    FileSystemEntity ent,
    bool Function(String name, FileSystemEntity entity)? filter,
    bool noFileContents) async {
  var name = p.basename(ent.path);
  if (filter != null && !filter(name, ent)) {
    return;
  }
  if (ent is Directory) {
    map[name] = await directoryToMap(ent.path,
        filter: filter, noFileContents: noFileContents);
  } else if (noFileContents) {
    map[name] = null;
  } else {
    var byteString = hex.encode(await (ent as File).readAsBytes());
    map[name] = byteString;
  }
}
