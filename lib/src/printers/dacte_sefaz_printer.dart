//lib/src/printers/dacte_sefaz_printer.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/dacte/dacte_data.dart';

class DacteSefazPrinter {
  final DacteData data;
  static final _numberFormat = NumberFormat.currency(
    symbol: '',
    decimalDigits: 2,
    locale: 'pt_BR',
  );

  DacteSefazPrinter(this.data);

  Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (context) => [
          _buildHeader(),
          pw.SizedBox(height: 2),
          _buildMunicipios(),
          pw.SizedBox(height: 2),
          _buildParticipantes(),
          pw.SizedBox(height: 2),
          _buildCarga(),
          pw.SizedBox(height: 2),
          _buildServico(),
          pw.SizedBox(height: 2),
          _buildObservacoes(),
        ],
      ),
    );

    return pdf.save();
  }

  // ============================
  // ESTILOS E HELPERS
  // ============================

  static final _labelStyle = pw.TextStyle(
    fontSize: 6,
    fontWeight: pw.FontWeight.bold,
  );
  static final _valueStyle = pw.TextStyle(fontSize: 7);
  static final _valueBoldStyle = pw.TextStyle(
    fontSize: 7,
    fontWeight: pw.FontWeight.bold,
  );
  static final _titleStyle = pw.TextStyle(
    fontSize: 8,
    fontWeight: pw.FontWeight.bold,
  );

  pw.Widget _box({
    required pw.Widget child,
    double? height,
    double? width,
    pw.EdgeInsets? padding,
  }) {
    return pw.Container(
      height: height,
      width: width,
      padding: padding ?? const pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: child,
    );
  }

  pw.Widget _label(String text) =>
      pw.Text(text.toUpperCase(), style: _labelStyle);
  pw.Widget _value(String text, {bool bold = false}) =>
      pw.Text(text, style: bold ? _valueBoldStyle : _valueStyle);

  String _format(double value) => _numberFormat.format(value).trim();

  // ============================
  // SEÇÕES DO DACTE
  // ============================

  pw.Widget _buildHeader() {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 40,
          child: _box(
            height: 90,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(data.emitente.nome.toUpperCase(), style: _titleStyle),
                _value(data.emitente.enderecoCompleto),
                _value('CNPJ: ${data.emitente.cnpjCpf}'),
                _value('IE: ${data.emitente.ie}'),
              ],
            ),
          ),
        ),
        pw.Expanded(
          flex: 20,
          child: _box(
            height: 90,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('DACTE',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text('Documento Auxiliar do',
                    style: pw.TextStyle(fontSize: 6)),
                pw.Text('Conhecimento de Transporte',
                    style: pw.TextStyle(fontSize: 6)),
                pw.Text('Eletrônico', style: pw.TextStyle(fontSize: 6)),
                pw.SizedBox(height: 4),
                _value('MODAL: RODOVIÁRIO', bold: true),
                pw.SizedBox(height: 4),
                _value('MODELO: ${data.modelo}', bold: true),
                _value('SERIE: ${data.serie}', bold: true),
                _value('NUMERO: ${data.numero}', bold: true),
              ],
            ),
          ),
        ),
        pw.Expanded(
          flex: 40,
          child: _box(
            height: 90,
            child: pw.Column(
              children: [
                pw.Container(
                  height: 35,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.code128(),
                    data: data.chaveAcesso,
                    drawText: false,
                  ),
                ),
                pw.SizedBox(height: 2),
                _label('CHAVE DE ACESSO'),
                pw.Text(data.chaveAcesso,
                    style: pw.TextStyle(fontSize: 7, font: pw.Font.courier())),
                pw.SizedBox(height: 2),
                _value('Protocolo: ${data.protocoloAutorizacao}', bold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildMunicipios() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _box(
            height: 25,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _label('MUNICÍPIO DE ORIGEM'),
                _value('${data.municipioOrigem} - ${data.ufOrigem}'),
              ],
            ),
          ),
        ),
        pw.Expanded(
          child: _box(
            height: 25,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _label('MUNICÍPIO DE DESTINO'),
                _value('${data.municipioDestino} - ${data.ufDestino}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildParticipantes() {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Expanded(child: _participantBox('REMETENTE', data.remetente)),
            pw.Expanded(
                child: _participantBox('DESTINATÁRIO', data.destinatario)),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(child: _participantBox('EXPEDIDOR', data.expedidor)),
            pw.Expanded(child: _participantBox('RECEBEDOR', data.recebedor)),
          ],
        ),
        _participantBox('TOMADOR DO SERVIÇO', data.tomador),
      ],
    );
  }

  pw.Widget _participantBox(String title, ParticipanteDacte? p) {
    return _box(
      height: 40,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _label(title),
          if (p != null) ...[
            _value(p.nome, bold: true),
            _value('${p.enderecoCompleto} - CNPJ: ${p.cnpjCpf} - IE: ${p.ie}'),
          ] else
            _value('-'),
        ],
      ),
    );
  }

  pw.Widget _buildCarga() {
    return _box(
      child: pw.Column(
        children: [
          pw.Row(children: [_label('INFORMAÇÕES DA CARGA')]),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('PRODUTO PREDOMINANTE'),
                    _value(data.produtoPredominante),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('PESO BRUTO (KG)'),
                    _value(_format(data.pesoBruto)),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR TOTAL DA CARGA'),
                    _value(_format(data.valorCarga)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildServico() {
    return pw.Column(
      children: [
        pw.Row(children: [_label('COMPONENTES DO VALOR DO SERVIÇO')]),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 30,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR TOTAL DO SERVIÇO'),
                    _value(_format(data.totais.valorTotalServico), bold: true),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 30,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR A RECEBER'),
                    _value(_format(data.totais.valorReceber), bold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildObservacoes() {
    return _box(
      height: 60,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _label('OBSERVAÇÕES'),
          _value(data.informacoesComplementares),
        ],
      ),
    );
  }
}
