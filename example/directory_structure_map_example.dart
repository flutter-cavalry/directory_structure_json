import 'package:directory_structure_map/directory_structure_map.dart';

void main() async {
  var map = await directoryToMap('.');
  print(map);
}
