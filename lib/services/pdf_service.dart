import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:kursliste_app/models/project.dart';

class PdfService {
  /// Creates a PDF listing project info and courses, then shares it
  static Future<void> createAndSharePdf(Project project) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Sætren AS',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text('Telefon: 123 45 678', style: pw.TextStyle(fontSize: 12)),
              pw.Text('www.saetren.no', style: pw.TextStyle(fontSize: 12)),
              pw.Divider(),

              // Project details
              pw.Text(
                'Kunde: ${project.customerName}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Fordelingstype: ${project.fordelingstype}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Systemspenning: ${project.systemspenning}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Jordelektrode Type: ${project.jordElektrodeType}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Jordelektrode Sted: ${project.jordElektrodeSted}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.Text(
                'Kortslutningsverdier: ${project.kortslutningsverdier}',
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 10),

              // Course table
              pw.Table.fromTextArray(
                headers: [
                  'Kurs nr.',
                  'Beskrivelse',
                  'Sikringstype',
                  'Ampere',
                  'Karakteristikk',
                  'Kabel tverrsnitt',
                  'Lengde',
                  'Jordfeilbryter',
                  'Forl. måte',
                ],
                data: project.courses.map((course) {
                  if (course.isPlaceholder) {
                    // blank row
                    return List<String>.filled(9, '');
                  }
                  String safe(String value) => (value.isEmpty) ? '-' : value;
                  return [
                    safe(course.kursNr),
                    safe(course.description),
                    safe(course.fuseType),
                    safe(course.ampereRating),
                    safe(course.characteristic),
                    safe(course.cableCrossSection),
                    safe(course.length),
                    safe(course.earthFaultBreaker),
                    safe(course.forlMaate),
                  ];
                }).toList(),
                cellStyle: pw.TextStyle(fontSize: 10),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    // Save PDF file
    final Uint8List pdfData = await pdf.save();

    // Share PDF
    await Printing.sharePdf(
      bytes: pdfData,
      filename:
          '${project.customerName} - ${DateTime.now().toIso8601String()}.pdf',
    );
  }
}
