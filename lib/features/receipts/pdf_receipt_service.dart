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
                      'MIRE SUNSET',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight:
                        pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('123 Cafe Street, Manila'),
                    pw.Text('TIN: 000-000-000-000'),
                    pw.Text('MIN: 240000000'),

                    pw.SizedBox(height: 5),
                    pw.Text(
                      'SALES INVOICE',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text(
                      receipt.createdAt.toString().split('.')[0],
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
              pw.Divider(),
              pw.SizedBox(height: 5),

              _vatRow('VATable Sales', receipt.vatableSales),
              _vatRow('VAT Amount (12%)', receipt.vatAmount),
              _vatRow('VAT Exempt Sales', receipt.exemptSales),

              pw.SizedBox(height: 10),

              pw.Text(
                'Payment: ${receipt.paymentMethod.toUpperCase()}',
              ),

              pw.Text(
                'Invoice No: ${receipt.receiptNumber}',
              ),

              pw.SizedBox(height: 15),
              
              pw.Text('Accreditation No: 000-000000000-000'),
              pw.Text('Date Issued: MM/DD/YYYY'),
              pw.SizedBox(height: 10),

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
              
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'BIR EOPT COMPLIANT SYSTEM',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _vatRow(String label, double amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(amount.toStringAsFixed(2), style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
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
      '${directory.path}/invoice_${receipt.orderId}.pdf',
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
