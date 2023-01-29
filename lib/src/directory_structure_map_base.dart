import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:convert/convert.dart';

Future<Map<String, dynamic>> directoryToMap(String dirPath,
    {bool Function(String name, FileSystemEntity entity)? filter}) async {
  Map<String, dynamic> map = {};
  await _directoryToMapInternal(map, Directory(dirPath), filter);
  return map;
}

Future<void> _directoryToMapInternal(Map<String, dynamic> map, Directory dir,
    bool Function(String name, FileSystemEntity entity)? filter) async {
  var entities = await dir.list().toList();
  await Future.wait(entities.map((e) => _entityToMapInternal(map, e, filter)));
}

Future<void> _entityToMapInternal(
    Map<String, dynamic> map,
    FileSystemEntity ent,
    bool Function(String name, FileSystemEntity entity)? filter) async {
  var name = p.basename(ent.path);
  if (filter != null && !filter(name, ent)) {
    return;
  }
  if (ent is Directory) {
    map[name] = await directoryToMap(ent.path, filter: filter);
  } else {
    var byteString = hex.encode(await (ent as File).readAsBytes());
    map[name] = byteString;
  }
}
