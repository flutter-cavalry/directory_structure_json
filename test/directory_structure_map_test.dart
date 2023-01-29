import 'dart:io';

import 'package:directory_structure_map/directory_structure_map.dart';
import 'package:test/test.dart';
import 'package:tmp_path/src/tmp_path.dart';
import 'package:path/path.dart' as p;

Future<String> setupEnv() async {
  // Create a tmp dir.
  var tmpDir = Directory(tmpPath());
  await tmpDir.create(recursive: true);
  await File(p.join(tmpDir.path, 'root.txt')).writeAsString('hi');
  await Directory(p.join(tmpDir.path, 'emptyDir')).create();
  var deepDir = Directory(p.join(tmpDir.path, 'a/b/c'));
  await deepDir.create(recursive: true);
  await File(p.join(deepDir.path, 'root.txt')).writeAsString('deep');
  return tmpDir.path;
}

void main() {
  test('Directory to map', () async {
    var dir = await setupEnv();
    expect(await directoryToMap(dir), {
      'emptyDir': {},
      'root.txt': '6869',
      'a': {
        'b': {
          'c': {'root.txt': '64656570'}
        }
      }
    });
  });

  test('Filter', () async {
    var dir = await setupEnv();
    expect(
        await directoryToMap(
          dir,
          filter: (name, entity) => name != 'c',
        ),
        {
          'emptyDir': {},
          'root.txt': '6869',
          'a': {'b': {}}
        });
  });
}
