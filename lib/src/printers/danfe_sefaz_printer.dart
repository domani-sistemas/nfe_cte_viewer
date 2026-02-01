import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/danfe/danfe_data.dart';

/// Printer responsável por gerar o PDF do DANFE seguindo rigorosamente o padrão SEFAZ.
class DanfeSefazPrinter {
  final DanfeData data;
  static final _numberFormat = NumberFormat.currency(
    symbol: '',
    decimalDigits: 2,
    locale: 'pt_BR',
  );

  DanfeSefazPrinter(this.data);

  Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(12),
        build: (context) => [
          _buildCanhoto(),
          pw.SizedBox(height: 4),
          _buildHeader(),
          pw.SizedBox(height: 2),
          _buildDestinatario(),
          pw.SizedBox(height: 2),
          _buildFaturas(),
          pw.SizedBox(height: 2),
          _buildImpostos(),
          pw.SizedBox(height: 2),
          _buildTransporte(),
          pw.SizedBox(height: 2),
          pw.Row(children: [_label('DADOS DO PRODUTO / SERVIÇO')]),
          _buildItensHeader(),
          ...data.itens.map((item) => _buildItensRow(item)),
          pw.SizedBox(height: 2),
          _buildDadosAdicionais(),
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    return pdf.save();
  }

  // ============================
  // ESTILOS E HELPERS
  // ============================

  static final _labelStyle = pw.TextStyle(
    fontSize: 5,
    fontWeight: pw.FontWeight.bold,
  );
  static final _valueStyle = pw.TextStyle(fontSize: 6.5);
  static final _titleStyle = pw.TextStyle(
    fontSize: 8,
    fontWeight: pw.FontWeight.bold,
  );
  static final _valueBoldStyle = pw.TextStyle(
    fontSize: 6.5,
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
  pw.Widget _value(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
    bool bold = false,
  }) =>
      pw.Text(
        text,
        style: bold ? _valueBoldStyle : _valueStyle,
        textAlign: align,
      );

  String _format(double value) => _numberFormat.format(value).trim();

  // ============================
  // SEÇÕES DO DANFE
  // ============================

  pw.Widget _buildCanhoto() {
    return _box(
      height: 40,
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _value(
                  'RECEBEMOS DE ${data.emitente.nome} OS PRODUTOS/SERVIÇOS CONSTANTES NA NOTA FISCAL INDICADA AO LADO',
                ),
                pw.Spacer(),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _label('DATA DE RECEBIMENTO'),
                          pw.Divider(thickness: 0.5, color: PdfColors.black),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 4),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _label('IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR'),
                            pw.Divider(thickness: 0.5, color: PdfColors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.Container(
            width: 80,
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              border: pw.Border(left: pw.BorderSide(width: 0.5)),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'NF-e',
                  style: _valueBoldStyle.copyWith(fontSize: 10),
                ),
                pw.Text('Nº ${data.numero}', style: _valueBoldStyle),
                pw.Text('SÉRIE ${data.serie}', style: _valueBoldStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHeader() {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            // Emitter
            pw.Expanded(
              flex: 35,
              child: _box(
                height: 90,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      data.emitente.nome.toUpperCase(),
                      style: _titleStyle,
                    ),
                    pw.SizedBox(height: 2),
                    _value(data.emitente.enderecoCompleto),
                    _value(
                      'CEP: ${data.emitente.cep} - Fone: ${data.emitente.fone}',
                    ),
                  ],
                ),
              ),
            ),
            // DANFE Info
            pw.Expanded(
              flex: 20,
              child: _box(
                height: 90,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'DANFE',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Documento Auxiliar da',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      'Nota Fiscal Eletrônica',
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          width: 14,
                          height: 14,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(width: 0.5),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              data.isSaida ? '1' : '0',
                              style: _valueBoldStyle,
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 4),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '0-ENTRADA',
                              style: pw.TextStyle(fontSize: 5),
                            ),
                            pw.Text(
                              '1-SAÍDA',
                              style: pw.TextStyle(fontSize: 5),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Nº ${data.numero}', style: _valueBoldStyle),
                    pw.Text('SÉRIE ${data.serie}', style: _valueBoldStyle),
                    pw.Text('Folha 1/1', style: _valueStyle),
                  ],
                ),
              ),
            ),
            // Access Key / Barcode
            pw.Expanded(
              flex: 45,
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
                    pw.SizedBox(height: 4),
                    _label('CHAVE DE ACESSO'),
                    pw.Text(
                      data.chaveAcesso,
                      style: pw.TextStyle(fontSize: 8, font: pw.Font.courier()),
                    ),
                    pw.SizedBox(height: 4),
                    _value(
                      'Consulta de autenticidade no portal nacional da NF-e',
                      align: pw.TextAlign.center,
                    ),
                    _value(
                      'www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora',
                      align: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 55,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('NATUREZA DA OPERAÇÃO'),
                    _value(data.naturezaOperacao),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 45,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('PROTOCOLO DE AUTORIZAÇÃO DE USO'),
                    _value(data.protocoloAutorizacao),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('INSCRIÇÃO ESTADUAL'),
                    _value(data.emitente.ie),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('INSCRIÇÃO ESTADUAL DO SUBST. TRIB.'),
                    _value('-'),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('CNPJ'), _value(data.emitente.cnpj)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDestinatario() {
    return _box(
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Text('DESTINATÁRIO / REMETENTE', style: _labelStyle),
              pw.Spacer(),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 70,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('NOME / RAZÃO SOCIAL'),
                      _value(data.destinatario.nome),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 20,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('CNPJ / CPF'),
                      _value(data.destinatario.cnpjCpf),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('DATA DA EMISSÃO'),
                      _value(data.destinatario.dataEmissao),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 50,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('ENDEREÇO'),
                      _value(data.destinatario.enderecoCompleto),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 30,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('BAIRRO / DISTRITO'),
                      _value(data.destinatario.bairro),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [_label('CEP'), _value(data.destinatario.cep)],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('DATA SAÍDA/ENTRADA'),
                      _value(data.destinatario.dataEmissao),
                    ],
                  ),
                ),
              ),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 40,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('MUNICÍPIO'),
                      _value(data.destinatario.municipio),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [_label('UF'), _value(data.destinatario.uf)],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('FONE / FAX'),
                      _value(data.destinatario.fone),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 30,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('INSCRIÇÃO ESTADUAL'),
                      _value(data.destinatario.ie),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 20,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [_label('HORA DA SAÍDA'), _value('00:00')],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFaturas() {
    return _box(
      child: pw.Column(
        children: [
          pw.Row(children: [pw.Text('FATURA / DUPLICATA', style: _labelStyle)]),
          pw.SizedBox(height: 4),
          _value('Não vinculada a duplicatas'),
        ],
      ),
    );
  }

  pw.Widget _buildImpostos() {
    return pw.Column(
      children: [
        pw.Row(children: [_label('CÁLCULO DO IMPOSTO')]),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('BASE DE CÁLCULO DO ICMS'),
                    _value(
                      _format(data.totais.baseIcms),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR DO ICMS'),
                    _value(
                      _format(data.totais.valorIcms),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('BASE DE CÁLCULO DO ICMS ST'),
                    _value(
                      _format(data.totais.baseIcmsSt),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR DO ICMS ST'),
                    _value(
                      _format(data.totais.valorIcmsSt),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR TOTAL DOS PRODUTOS'),
                    _value(
                      _format(data.totais.valorProdutos),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR DO FRETE'),
                    _value(
                      _format(data.totais.valorFrete),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR DO SEGURO'),
                    _value(
                      _format(data.totais.valorSeguro),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('DESCONTO'),
                    _value(
                      _format(data.totais.valorDesconto),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('OUTRAS DESPESAS ACESSÓRIAS'),
                    _value(
                      _format(data.totais.outrasDespesas),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR DO IPI'),
                    _value(
                      _format(data.totais.valorIpi),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR TOTAL DA NOTA'),
                    _value(
                      _format(data.totais.valorTotalNota),
                      align: pw.TextAlign.right,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTransporte() {
    final t = data.transporte;
    return pw.Column(
      children: [
        pw.Row(children: [_label('TRANSPORTADOR / VOLUMES TRANSPORTADOS')]),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 70,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('RAZÃO SOCIAL'),
                    _value(t.transportadorNome),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 10,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('FRETE POR CONTA'),
                    _value(t.modalidadeFrete),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 10,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('CÓDIGO ANTT'), _value('-')],
                ),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('PLACA DO VEÍCULO'),
                    _value(t.placaVeiculo),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 10,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('UF'), _value(t.ufVeiculo)],
                ),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('CNPJ / CPF'),
                    _value(t.transportadorCnpjCpf),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 50,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('ENDEREÇO'),
                    _value(t.transportadoraEndereco),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 30,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('MUNICÍPIO'),
                    _value(t.transportadoraMunicipio),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 10,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('UF'), _value(t.transportadoraUf)],
                ),
              ),
            ),
            pw.Expanded(
              flex: 30,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('INSCRIÇÃO ESTADUAL'),
                    _value(t.transportadoraIe),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('QUANTIDADE'), _value(t.quantidade)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('ESPÉCIE'), _value(t.especie)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('MARCA'), _value(t.marca)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('NUMERAÇÃO'), _value(t.numeracao)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('PESO BRUTO'),
                    _value(_format(t.pesoBruto), align: pw.TextAlign.right),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('PESO LÍQUIDO'),
                    _value(_format(t.pesoLiquido), align: pw.TextAlign.right),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Célula da tabela de itens com borda e texto alinhado à esquerda
  pw.Widget _cell(String text,
      {bool bold = false, pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Text(
        text,
        style: bold ? _labelStyle : _valueStyle,
        textAlign: align,
      ),
    );
  }

  /// Cabeçalho da tabela de itens (uma única linha com os títulos das colunas)
  pw.Widget _buildItensHeader() {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(40),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FixedColumnWidth(35),
        3: const pw.FixedColumnWidth(25),
        4: const pw.FixedColumnWidth(25),
        5: const pw.FixedColumnWidth(20),
        6: const pw.FixedColumnWidth(40),
        7: const pw.FixedColumnWidth(40),
        8: const pw.FixedColumnWidth(40),
        9: const pw.FixedColumnWidth(40),
        10: const pw.FixedColumnWidth(30),
        11: const pw.FixedColumnWidth(30),
        12: const pw.FixedColumnWidth(20),
        13: const pw.FixedColumnWidth(20),
      },
      children: [
        pw.TableRow(children: [
          _cell('CÓDIGO', bold: true),
          _cell('DESCRIÇÃO DO PRODUTO / SERVIÇO', bold: true),
          _cell('NCM/SH', bold: true),
          _cell('CFOP', bold: true),
          _cell('CST', bold: true),
          _cell('UN', bold: true),
          _cell('QTD.', bold: true),
          _cell('V.UNIT', bold: true),
          _cell('V.TOTAL', bold: true),
          _cell('BC ICMS', bold: true),
          _cell('V.ICMS', bold: true),
          _cell('V.IPI', bold: true),
          _cell('%ICMS', bold: true),
          _cell('%IPI', bold: true),
        ]),
      ],
    );
  }

  /// Uma linha individual de item — cada uma é um widget separado no MultiPage
  pw.Widget _buildItensRow(dynamic item) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(40),
        1: const pw.FlexColumnWidth(2),
        2: const pw.FixedColumnWidth(35),
        3: const pw.FixedColumnWidth(25),
        4: const pw.FixedColumnWidth(25),
        5: const pw.FixedColumnWidth(20),
        6: const pw.FixedColumnWidth(40),
        7: const pw.FixedColumnWidth(40),
        8: const pw.FixedColumnWidth(40),
        9: const pw.FixedColumnWidth(40),
        10: const pw.FixedColumnWidth(30),
        11: const pw.FixedColumnWidth(30),
        12: const pw.FixedColumnWidth(20),
        13: const pw.FixedColumnWidth(20),
      },
      children: [
        pw.TableRow(children: [
          _cell(item.codigo),
          _cell(item.descricao),
          _cell(item.ncm),
          _cell(item.cfop),
          _cell(item.cst),
          _cell(item.unidade),
          _cell(_format(item.quantidade), align: pw.TextAlign.right),
          _cell(_format(item.valorUnitario), align: pw.TextAlign.right),
          _cell(_format(item.valorTotal), align: pw.TextAlign.right),
          _cell(_format(item.baseIcms), align: pw.TextAlign.right),
          _cell(_format(item.valorIcms), align: pw.TextAlign.right),
          _cell(_format(item.valorIpi), align: pw.TextAlign.right),
          _cell(_format(item.aliqIcms), align: pw.TextAlign.right),
          _cell(_format(item.aliqIpi), align: pw.TextAlign.right),
        ]),
      ],
    );
  }

  pw.Widget _buildDadosAdicionais() {
    return pw.Column(
      children: [
        pw.Row(children: [_label('DADOS ADICIONAIS')]),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 60,
              child: _box(
                height: 100,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('INFORMAÇÕES COMPLEMENTARES'),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      data.dadosAdicionais.informacoesComplementares,
                      style: pw.TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 40,
              child: _box(
                height: 100,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('RESERVADO AO FISCO'),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      data.dadosAdicionais.informacoesFisco,
                      style: pw.TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Gerado por nfe_cte_viewer - Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(fontSize: 5),
      ),
    );
  }
}
