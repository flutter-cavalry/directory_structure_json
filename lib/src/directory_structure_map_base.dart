import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:convert/convert.dart';

Future<Map<String, dynamic>> directoryToMap(String dirPath) async {
  Map<String, dynamic> map = {};
  await _directoryToMapInternal(map, Directory(dirPath));
  return map;
}

Future<void> _directoryToMapInternal(
    Map<String, dynamic> map, Directory dir) async {
  var entities = await dir.list().toList();
  await Future.wait(entities.map((e) => _entityToMapInternal(map, e)));
}

Future<dynamic> _entityToMapInternal(
    Map<String, dynamic> map, FileSystemEntity ent) async {
  var name = p.basename(ent.path);
  if (ent is Directory) {
    map[name] = await directoryToMap(ent.path);
  } else {
    var byteString = hex.encode(await (ent as File).readAsBytes());
    map[name] = byteString;
  }
}
