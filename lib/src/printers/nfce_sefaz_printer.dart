//lib/src/printers/nfce_sefaz_printer.dart

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/nfce/nfce_data.dart';

class NfceSefazPrinter {
  final NfceData data;
  static final _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  NfceSefazPrinter(this.data);

  static final _fontNormal = pw.TextStyle(fontSize: 7);
  static final _fontBold =
      pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold);
  static final _fontTitle =
      pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);
  static final _fontSmall = pw.TextStyle(fontSize: 6);

  Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(
          80 * PdfPageFormat.mm,
          200 * PdfPageFormat.cm,
          marginAll: 5 * PdfPageFormat.mm,
        ),
        build: (context) => [
          _buildHeader(),
          _buildDivider(),
          _buildTituloDoc(),
          _buildDivider(),
          _buildItens(),
          _buildDivider(),
          _buildTotals(),
          _buildDivider(),
          _buildPagamentos(),
          _buildDivider(),
          _buildDadosEntrega(),
          _buildDivider(),
          _buildChaveAcesso(),
          _buildDivider(),
          _buildConsumidor(),
          _buildDivider(),
          _buildInfProt(),
          _buildDivider(),
          _buildQrCode(),
          _buildDivider(),
          _buildFooter(),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader() {
    return pw.Column(
      children: [
        pw.Text(data.emitente.nome.toUpperCase(),
            style: _fontBold, textAlign: pw.TextAlign.center),
        pw.Text('CNPJ: ${data.emitente.cnpj}', style: _fontNormal),
        pw.Text(data.emitente.endereco,
            style: _fontSmall, textAlign: pw.TextAlign.center),
      ],
      crossAxisAlignment: pw.CrossAxisAlignment.center,
    );
  }

  pw.Widget _buildTituloDoc() {
    return pw.Column(
      children: [
        pw.Text('DANFE NFC-e', style: _fontTitle),
        pw.Text('Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica',
            style: _fontSmall, textAlign: pw.TextAlign.center),
        if (data.ambiente == '2')
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            child: pw.Text('ÁREA DE HOMOLOGAÇÃO - SEM VALOR FISCAL',
                style: _fontBold.copyWith(fontSize: 8)),
          ),
      ],
      crossAxisAlignment: pw.CrossAxisAlignment.center,
    );
  }

  pw.Widget _buildItens() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Expanded(flex: 2, child: pw.Text('Cód/Descr', style: _fontBold)),
            pw.Expanded(
                child: pw.Text('Qtde/Un',
                    style: _fontBold, textAlign: pw.TextAlign.right)),
            pw.Expanded(
                child: pw.Text('V.Unit',
                    style: _fontBold, textAlign: pw.TextAlign.right)),
            pw.Expanded(
                child: pw.Text('V.Total',
                    style: _fontBold, textAlign: pw.TextAlign.right)),
          ],
        ),
        pw.SizedBox(height: 2),
        ...data.itens.map((i) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('${i.codigo} ${i.descricao}', style: _fontSmall),
                  pw.Row(
                    children: [
                      pw.Expanded(flex: 2, child: pw.SizedBox()),
                      pw.Expanded(
                          child: pw.Text(
                              '${_format(i.quantidade)} ${i.unidade}',
                              style: _fontSmall,
                              textAlign: pw.TextAlign.right)),
                      pw.Expanded(
                          child: pw.Text(_format(i.valorUnitario),
                              style: _fontSmall,
                              textAlign: pw.TextAlign.right)),
                      pw.Expanded(
                          child: pw.Text(_format(i.valorTotal),
                              style: _fontSmall,
                              textAlign: pw.TextAlign.right)),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  pw.Widget _buildTotals() {
    return pw.Column(
      children: [
        _rowTotal(
            'Qtd. Total de Itens', data.totais.qtdItens.toInt().toString()),
        _rowTotal(
            'Valor Total Produtos', _format(data.totais.valorTotalProdutos)),
        if (data.totais.valorDesconto > 0)
          _rowTotal('Desconto', _format(data.totais.valorDesconto)),
        _rowTotal('VALOR TOTAL', _format(data.totais.valorTotalNota),
            bold: true),
      ],
    );
  }

  pw.Widget _buildPagamentos() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('FORMA DE PAGAMENTO', style: _fontBold),
        pw.SizedBox(height: 2),
        ...data.pagamentos.map((p) => _rowTotal(p.forma, _format(p.valor))),
      ],
    );
  }

  pw.Widget _buildDadosEntrega() {
    return pw.Column(
      children: [
        pw.Text('Informações de interesse do contribuinte:', style: _fontBold),
        pw.Text(
            'VALOR APROXIMADO DOS TRIBUTOS: R\$ ${_format(data.totais.valorTributos)}',
            style: _fontSmall),
      ],
      crossAxisAlignment: pw.CrossAxisAlignment.start,
    );
  }

  pw.Widget _buildChaveAcesso() {
    return pw.Column(
      children: [
        pw.Text('CHAVE DE ACESSO', style: _fontBold),
        pw.Text(_formatChave(data.chaveAcesso),
            style: _fontSmall, textAlign: pw.TextAlign.center),
      ],
    );
  }

  pw.Widget _buildConsumidor() {
    final dest = data.destinatario;
    if (dest == null || dest.cnpjCpf == null) {
      return pw.Text('CONSUMIDOR NÃO IDENTIFICADO',
          style: _fontNormal, textAlign: pw.TextAlign.center);
    }
    return pw.Column(
      children: [
        pw.Text('CONSUMIDOR: ${dest.nome ?? ''}', style: _fontNormal),
        pw.Text('CNPJ/CPF: ${dest.cnpjCpf}', style: _fontNormal),
        if (dest.endereco != null) pw.Text(dest.endereco!, style: _fontSmall),
      ],
      crossAxisAlignment: pw.CrossAxisAlignment.center,
    );
  }

  pw.Widget _buildInfProt() {
    return pw.Column(
      children: [
        pw.Text(
            'NFC-e nº ${data.numero} Série ${data.serie} Emissão ${data.dataEmissao}',
            style: _fontSmall,
            textAlign: pw.TextAlign.center),
        pw.Text('Protocolo de Autorização: ${data.protocoloAutorizacao}',
            style: _fontSmall, textAlign: pw.TextAlign.center),
      ],
    );
  }

  pw.Widget _buildQrCode() {
    if (data.qrCode.isEmpty) return pw.SizedBox();
    return pw.Column(
      children: [
        pw.Container(
          height: 80,
          width: 80,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: data.qrCode,
            drawText: false,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text('Consulta via leitor de QR Code', style: _fontSmall),
      ],
      crossAxisAlignment: pw.CrossAxisAlignment.center,
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Text('Consulta em: ${data.urlConsulta}',
            style: _fontSmall, textAlign: pw.TextAlign.center),
      ],
    );
  }

  pw.Widget _buildDivider() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Divider(
          height: 0.5,
          thickness: 0.5,
          color: PdfColors.black,
          borderStyle: pw.BorderStyle.dashed),
    );
  }

  pw.Widget _rowTotal(String label, String value, {bool bold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: bold ? _fontBold : _fontNormal),
        pw.Text(value, style: bold ? _fontBold : _fontNormal),
      ],
    );
  }

  String _format(double value) {
    return _currencyFormat.format(value).trim();
  }

  String _formatChave(String chave) {
    if (chave.length != 44) return chave;
    return '${chave.substring(0, 4)} ${chave.substring(4, 8)} ${chave.substring(8, 12)} ${chave.substring(12, 16)} '
        '${chave.substring(16, 20)} ${chave.substring(20, 24)} ${chave.substring(24, 28)} ${chave.substring(28, 32)} '
        '${chave.substring(32, 36)} ${chave.substring(36, 40)} ${chave.substring(40, 44)}';
  }
}
