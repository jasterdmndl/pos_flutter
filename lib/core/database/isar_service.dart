import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'collections/order_entity.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        OrderEntitySchema,
      ],
      directory: dir.path,
    );
  }
}