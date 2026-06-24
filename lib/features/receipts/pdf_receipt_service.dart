import 'dart:io';
import 'package:open_filex/open_filex.dart';
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
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (context) {
          return pw.Column(
            crossAxisAlignment:
            pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'CAFE POS',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight:
                        pw.FontWeight.bold,
                      ),
                    ),

                    pw.Text(
                      'Official Receipt',
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text(
                      order.createdAt.toString(),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Divider(),

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
                        pw.Expanded(
                          child: pw.Text(
                            '${item.product.name} x${item.quantity}',
                          ),
                        ),

                        pw.Text(
                          'PHP ${item.subtotal.toStringAsFixed(2)}',
                        ),
                      ],
                    ),

                    ...item.addons.map(
                          (addon) => pw.Padding(
                        padding:
                        const pw.EdgeInsets.only(
                            left: 10),
                        child: pw.Text(
                          '+ ${addon.name} x${addon.quantity}',
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 5),
                  ],
                ),
              ),

              pw.Divider(),

              pw.Row(
                mainAxisAlignment:
                pw.MainAxisAlignment
                    .spaceBetween,
                children: [
                  pw.Text('Subtotal'),
                  pw.Text(
                    'PHP ${order.subtotal.toStringAsFixed(2)}',
                  ),
                ],
              ),

              pw.Row(
                mainAxisAlignment:
                pw.MainAxisAlignment
                    .spaceBetween,
                children: [
                  pw.Text('Discount'),
                  pw.Text(
                    'PHP ${order.discountAmount.toStringAsFixed(2)}',
                  ),
                ],
              ),

              pw.Divider(),

              pw.Row(
                mainAxisAlignment:
                pw.MainAxisAlignment
                    .spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontWeight:
                      pw.FontWeight.bold,
                    ),
                  ),

                  pw.Text(
                    'PHP ${order.total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight:
                      pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                'Payment: ${order.paymentMethod.name.toUpperCase()}',
              ),

              pw.SizedBox(height: 15),

              pw.Center(
                child: pw.Text(
                  'Thank You!',
                  style: pw.TextStyle(
                    fontWeight:
                    pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  'Please Come Again',
                ),
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

    await OpenFilex.open(file.path);

    return file;
  }
}