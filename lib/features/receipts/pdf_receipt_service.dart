import 'dart:io';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'receipt_data.dart';

class PdfReceiptService {
  Future<List<int>> generateReceiptBytes(
      ReceiptData receipt,
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
                      receipt.createdAt.toString(),
                      textAlign:
                      pw.TextAlign.center,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Divider(),

              ...receipt.items.map(
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
                            '${item.productName} x${item.quantity}',
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
                        const pw.EdgeInsets
                            .only(left: 10),
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
                    'PHP ${receipt.subtotal.toStringAsFixed(2)}',
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
                    'PHP ${receipt.discountAmount.toStringAsFixed(2)}',
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
                    'PHP ${receipt.total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontWeight:
                      pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                'Payment: ${receipt.paymentMethod.toUpperCase()}',
              ),

              pw.Text(
                'Order #: ${receipt.orderId}',
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

    return pdf.save();
  }

  Future<File> saveReceiptPdf(
      ReceiptData receipt,
      ) async {
    final bytes =
    await generateReceiptBytes(
      receipt,
    );

    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      '${directory.path}/receipt_${receipt.orderId}.pdf',
    );

    await file.writeAsBytes(bytes);

    return file;
  }
  Future<void> printReceipt(
      ReceiptData receipt,
      ) async {
    final bytes =
    await generateReceiptBytes(receipt);

    await Printing.layoutPdf(
      onLayout: (format) async =>
          Uint8List.fromList(bytes),
    );
  }
}