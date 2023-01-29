[![pub package](https://img.shields.io/pub/v/directory_structure_map.svg)](https://pub.dev/packages/directory_structure_map)
[![Build Status](https://github.com/flutter-cavalry/directory_structure_map/workflows/Build/badge.svg)](https://github.com/flutter-cavalry/directory_structure_map/actions)

Converts the contents of a directory to JSON.

## Usage

Suppose a directory structure:

```
-- a.txt
-- emptyDir
-- subDir
  -- b.txt
```

```dart
import 'package:directory_structure_map/directory_structure_map.dart';

void main() async {
  var map = await directoryToMap('./directoryPath');
  print(map);
}
```

Prints:

```js
{
  'emptyDir': {},
  'a.txt': '<File contents in hex>',
  'subDir': {
    'b.txt': '<File contents in hex>'
  }
}
```
