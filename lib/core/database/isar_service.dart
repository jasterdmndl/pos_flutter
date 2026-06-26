import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_flutter/core/database/collections/order_addon_entity.dart';
import 'package:pos_flutter/core/database/collections/order_item_entity.dart';
import 'package:pos_flutter/core/database/collections/category_entity.dart';
import 'package:pos_flutter/core/database/collections/product_entity.dart';
import 'package:pos_flutter/core/database/collections/ingredient_entity.dart';
import 'package:pos_flutter/core/database/collections/product_ingredient_entity.dart';
import 'package:pos_flutter/core/database/collections/user_entity.dart';
import 'package:pos_flutter/core/database/collections/product_addon_entity.dart';

import 'collections/order_entity.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        OrderEntitySchema,
        OrderItemEntitySchema,
        OrderAddonEntitySchema,
        CategoryEntitySchema,
        ProductEntitySchema,
        IngredientEntitySchema,
        ProductIngredientEntitySchema,
        UserEntitySchema,
        ProductAddonEntitySchema,
      ],
      directory: dir.path,
    );
  }
}