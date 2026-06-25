import 'package:isar/isar.dart';

import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';

import 'receipt_data.dart';

class ReceiptRepository {
  Future<ReceiptData?> getReceipt(
      int orderId,
      ) async {
    final order =
    await IsarService.isar.orderEntitys
        .get(orderId);

    if (order == null) {
      return null;
    }

    final orderItems =
    await IsarService.isar.orderItemEntitys
        .filter()
        .orderIdEqualTo(orderId)
        .findAll();

    final items = <ReceiptItem>[];

    for (final item in orderItems) {
      final addons =
      await IsarService.isar.orderAddonEntitys
          .filter()
          .orderItemIdEqualTo(item.id)
          .findAll();

      items.add(
        ReceiptItem(
          productName: item.productName,
          quantity: item.quantity,
          subtotal: item.subtotal,
          addons: addons
              .map(
                (a) => ReceiptAddon(
              name: a.addonName,
              quantity: a.quantity,
              subtotal: a.subtotal,
            ),
          )
              .toList(),
        ),
      );
    }

    return ReceiptData(
      orderId: order.id,
      subtotal: order.subtotal,
      discountAmount: order.discountAmount,
      total: order.total,
      paymentMethod: order.paymentMethod,
      createdAt: order.createdAt,
      items: items,
      receiptNumber: 'OR-${order.createdAt.year}-${order.id.toString().padLeft(6, '0')}',
    );
  }
}