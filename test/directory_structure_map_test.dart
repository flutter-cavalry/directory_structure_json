import 'dart:io';

import 'package:directory_structure_map/directory_structure_map.dart';
import 'package:test/test.dart';
import 'package:tmp_path/src/tmp_path.dart';
import 'package:path/path.dart' as p;

void main() {
  test('Directory to map', () async {
    // Create a tmp dir.
    var tmpDir = Directory(tmpPath());
    await tmpDir.create(recursive: true);
    await File(p.join(tmpDir.path, 'root.txt')).writeAsString('hi');
    await Directory(p.join(tmpDir.path, 'emptyDir')).create();
    var deepDir = Directory(p.join(tmpDir.path, 'a/b/c'));
    await deepDir.create(recursive: true);
    await File(p.join(deepDir.path, 'root.txt')).writeAsString('deep');

    expect(await directoryToMap(tmpDir.path), {
      'emptyDir': {},
      'root.txt': '6869',
      'a': {
        'b': {
          'c': {'root.txt': '64656570'}
        }
      }
    });
  });
}
