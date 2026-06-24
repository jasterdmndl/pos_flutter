import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../checkout/checkout_model.dart';

class PdfReceiptService {
  Future<File> generateReceipt(
      Order order,
      ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment:
            pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'CAFE POS',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight:
                    pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              ...order.items.map(
                    (item) => pw.Column(
                  crossAxisAlignment:
                  pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment:
                      pw.MainAxisAlignment
                          .spaceBetween,
                      children: [
                        pw.Text(
                          '${item.product.name} x${item.quantity}',
                        ),
                        pw.Text(
                          '₱${item.subtotal.toStringAsFixed(2)}',
                        ),
                      ],
                    ),

                    ...item.addons.map(
                          (addon) => pw.Padding(
                        padding:
                        const pw.EdgeInsets
                            .only(left: 20),
                        child: pw.Text(
                          '+ ${addon.name} x${addon.quantity}',
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 8),
                  ],
                ),
              ),

              pw.Divider(),

              pw.Text(
                'Subtotal: PHP ${order.subtotal.toStringAsFixed(2)}',
              ),

              pw.Text(
                'Discount: PHP ${order.discountAmount.toStringAsFixed(2)}',
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                'Total: PHP ${order.total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                'Payment: ${order.paymentMethod.name.toUpperCase()}',
              ),

              pw.Text(
                order.createdAt.toString(),
              ),
            ],
          );
        },
      ),
    );

    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/receipt_${order.id}.pdf',
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }
}