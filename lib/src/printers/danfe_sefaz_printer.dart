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
          _buildFaturas(), // Ocupa pouco espaço geralmente
          pw.SizedBox(height: 2),
          _buildImpostos(),
          pw.SizedBox(height: 2),
          _buildTransporte(),
          pw.SizedBox(height: 2),
          _buildItens(context),
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
    fontSize: 6,
    fontWeight: pw.FontWeight.bold,
  );
  static final _valueStyle = pw.TextStyle(fontSize: 7);
  static final _titleStyle = pw.TextStyle(
    fontSize: 8,
    fontWeight: pw.FontWeight.bold,
  );
  static final _valueBoldStyle = pw.TextStyle(
    fontSize: 7,
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
      height: 45,
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
                height: 100,
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
                height: 100,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'DANFE',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Documento Auxiliar da',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'Nota Fiscal Eletrônica',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Container(
                          width: 15,
                          height: 15,
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
                height: 100,
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 40,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                  height: 25,
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
                  height: 25,
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
                  height: 25,
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
                  height: 25,
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
                  height: 25,
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
                  height: 25,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [_label('CEP'), _value(data.destinatario.cep)],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 25,
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
                  height: 25,
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
                  height: 25,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [_label('UF'), _value(data.destinatario.uf)],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 10,
                child: _box(
                  height: 25,
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
                  height: 25,
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
                  height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('CÓDIGO ANTT'), _value('-')],
                ),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _box(
                height: 25,
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
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('UF'), _value(t.ufVeiculo)],
                ),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _box(
                height: 25,
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
                height: 25,
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
                height: 25,
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
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('UF'), _value(t.transportadoraUf)],
                ),
              ),
            ),
            pw.Expanded(
              flex: 30,
              child: _box(
                height: 25,
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
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('QUANTIDADE'), _value(t.quantidade)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('ESPÉCIE'), _value(t.especie)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('MARCA'), _value(t.marca)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 25,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('NUMERAÇÃO'), _value(t.numeracao)],
                ),
              ),
            ),
            pw.Expanded(
              child: _box(
                height: 25,
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
                height: 25,
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

  pw.Widget _buildItens(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(children: [_label('DADOS DO PRODUTO / SERVIÇO')]),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(width: 0.5),
          headerStyle: _labelStyle,
          cellStyle: _valueStyle,
          headerDecoration: pw.BoxDecoration(color: PdfColors.white),
          columnWidths: {
            0: const pw.FixedColumnWidth(40), // CÓD
            1: const pw.FlexColumnWidth(2), // DESCRIÇÃO
            2: const pw.FixedColumnWidth(35), // NCM
            3: const pw.FixedColumnWidth(25), // CFOP
            4: const pw.FixedColumnWidth(25), // CST
            5: const pw.FixedColumnWidth(20), // UN
            6: const pw.FixedColumnWidth(40), // QTD
            7: const pw.FixedColumnWidth(40), // VL UNIT
            8: const pw.FixedColumnWidth(40), // VL TOTAL
            9: const pw.FixedColumnWidth(40), // BC ICMS
            10: const pw.FixedColumnWidth(30), // VL ICMS
            11: const pw.FixedColumnWidth(30), // VL IPI
            12: const pw.FixedColumnWidth(20), // % ICMS
            13: const pw.FixedColumnWidth(20), // % IPI
          },
          headers: [
            'CÓDIGO',
            'DESCRIÇÃO DO PRODUTO / SERVIÇO',
            'NCM/SH',
            'CFOP',
            'CST',
            'UN',
            'QTD.',
            'V.UNIT',
            'V.TOTAL',
            'BC ICMS',
            'V.ICMS',
            'V.IPI',
            '%ICMS',
            '%IPI',
          ],
          data: data.itens
              .map(
                (i) => [
                  i.codigo,
                  i.descricao,
                  i.ncm,
                  i.cfop,
                  i.cst,
                  i.unidade,
                  _format(i.quantidade),
                  _format(i.valorUnitario),
                  _format(i.valorTotal),
                  _format(i.baseIcms),
                  _format(i.valorIcms),
                  _format(i.valorIpi),
                  _format(i.aliqIcms),
                  _format(i.aliqIpi),
                ],
              )
              .toList(),
        ),
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
        'Impresso por nfe_cte_viewer - Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(fontSize: 5),
      ),
    );
  }
}
