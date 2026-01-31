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
        margin: const pw.EdgeInsets.all(10),
        build: (context) => [
          _buildCanhoto(),
          pw.SizedBox(height: 2),
          _buildPerforationLine(),
          pw.SizedBox(height: 2),
          _buildHeader(),
          pw.SizedBox(height: 2),
          _buildTypeAndKeyInfo(),
          pw.SizedBox(height: 2),
          _buildNaturezaEProtocolo(),
          pw.SizedBox(height: 2),
          _buildPrestacaoInfo(),
          pw.SizedBox(height: 2),
          _buildParticipanteSection(
              'REMETENTE', data.remetente, 'DESTINATÁRIO', data.destinatario),
          pw.SizedBox(height: 2),
          _buildParticipanteSection(
              'EXPEDIDOR', data.expedidor, 'RECEBEDOR', data.recebedor),
          pw.SizedBox(height: 2),
          _buildTomadorFinal(),
          pw.SizedBox(height: 2),
          _buildCargaInfo(),
          pw.SizedBox(height: 2),
          _buildComponentesGrid(),
          pw.SizedBox(height: 2),
          _buildImpostoInfo(),
          pw.SizedBox(height: 2),
          _buildDocumentosOriginarios(),
          pw.SizedBox(height: 2),
          _buildObservacoes(),
          pw.SizedBox(height: 2),
          _buildDadosModal(),
          pw.SizedBox(height: 2),
          _buildFooterNote(),
        ],
      ),
    );

    return pdf.save();
  }

  // Styles
  static final _labelStyle =
      pw.TextStyle(fontSize: 5, fontWeight: pw.FontWeight.bold);
  static final _valueStyle = pw.TextStyle(fontSize: 7);
  static final _valueBoldStyle =
      pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold);
  static final _titleStyle =
      pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold);

  pw.Widget _box(
      {required pw.Widget child,
      double? height,
      double? width,
      pw.EdgeInsets? padding}) {
    return pw.Container(
      height: height,
      width: width,
      padding: padding ?? const pw.EdgeInsets.all(1),
      decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 0.5)),
      child: child,
    );
  }

  pw.Widget _cell(
      {required List<pw.Widget> children,
      double? height,
      double? width,
      pw.CrossAxisAlignment? cross}) {
    return pw.Container(
      height: height,
      width: width,
      padding: const pw.EdgeInsets.all(1),
      child: pw.Column(
        crossAxisAlignment: cross ?? pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  pw.Widget _label(String text) =>
      pw.Text(text.toUpperCase(), style: _labelStyle);
  pw.Widget _value(String text,
          {pw.TextAlign align = pw.TextAlign.left, bool bold = false}) =>
      pw.Text(text,
          style: bold ? _valueBoldStyle : _valueStyle, textAlign: align);

  String _format(double value) => _numberFormat.format(value).trim();

  // Sections
  pw.Widget _buildCanhoto() {
    return _box(
      height: 48,
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 8,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 2, left: 2),
                  child: pw.Text(
                      'DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold)),
                ),
                pw.Spacer(),
                pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _label('NOME'),
                              pw.Divider(thickness: 0.5)
                            ])),
                    pw.Expanded(
                        child: pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 4),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  _label('RG'),
                                  pw.Divider(thickness: 0.5)
                                ]))),
                    pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _label('ASSINATURA / CARIMBO'),
                              pw.Divider(thickness: 0.5)
                            ])),
                  ],
                ),
              ],
            ),
          ),
          pw.VerticalDivider(width: 1, color: PdfColors.black),
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              children: [
                pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                      _label('TÉRMINO DA PRESTAÇÃO - DATA/HORA'),
                      pw.Divider(thickness: 0.5, color: PdfColors.white)
                    ])),
                pw.Divider(thickness: 0.5),
                pw.Expanded(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [_label('INÍCIO DA PRESTAÇÃO - DATA/HORA')])),
              ],
            ),
          ),
          pw.VerticalDivider(width: 1, color: PdfColors.black),
          pw.Container(
            width: 85,
            padding: const pw.EdgeInsets.all(2),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('CT-E',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8)),
                _label('Nº. DOCUMENTO ${data.numero}'),
                _label('SÉRIE ${data.serie}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPerforationLine() {
    return pw.Container(
      height: 1,
      child: pw.Center(
        child: pw.Container(
          width: double.infinity,
          decoration: const pw.BoxDecoration(
            border: pw.Border(
                bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: 0.5,
                    style: pw.BorderStyle.dashed)),
          ),
        ),
      ),
    );
  }

  pw.Widget _buildHeader() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 40,
          child: _box(
            height: 75,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(data.emitente.nome,
                    style: _titleStyle, textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 2),
                _value(
                    data.emitente.logradouro +
                        ', ' +
                        data.emitente.numero +
                        (data.emitente.bairro.isNotEmpty
                            ? ' - ' + data.emitente.bairro
                            : ''),
                    align: pw.TextAlign.center),
                _value(
                    'CRP: ${data.emitente.cep} - ${data.emitente.municipio} - ${data.emitente.uf}',
                    align: pw.TextAlign.center),
                _value('Fone/Fax: ${data.emitente.fone}',
                    align: pw.TextAlign.center),
                pw.SizedBox(height: 2),
                _value(
                    'CNPJ/CPF: ${data.emitente.cnpjCpf}  Insc.Estadual: ${data.emitente.ie}',
                    align: pw.TextAlign.center,
                    bold: true),
              ],
            ),
          ),
        ),
        pw.Expanded(
          flex: 30,
          child: _box(
            height: 75,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('DACTE',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 9)),
                _value('Documento Auxiliar do Conhecimento',
                    align: pw.TextAlign.center),
                _value('de Transporte Eletrônico', align: pw.TextAlign.center),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    _cell(children: [
                      _label('MODELO'),
                      _value(data.modelo, bold: true)
                    ], cross: pw.CrossAxisAlignment.center),
                    pw.SizedBox(width: 4),
                    _cell(children: [
                      _label('SÉRIE'),
                      _value(data.serie, bold: true)
                    ], cross: pw.CrossAxisAlignment.center),
                    pw.SizedBox(width: 4),
                    _cell(children: [
                      _label('NÚMERO'),
                      _value(data.numero, bold: true)
                    ], cross: pw.CrossAxisAlignment.center),
                    pw.SizedBox(width: 4),
                    _cell(
                        children: [_label('FL'), _value('1/1', bold: true)],
                        cross: pw.CrossAxisAlignment.center),
                  ],
                ),
              ],
            ),
          ),
        ),
        pw.Expanded(
          flex: 30,
          child: _box(
            height: 75,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _value('MODAL', bold: true),
                pw.Text('Rodoviário',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 13)),
                pw.Divider(thickness: 0.5),
                _label('DATA E HORA DE EMISSÃO'),
                _value(data.dataEmissao, bold: true),
                _label('INSC. SUFRAMA DO DESTINATÁRIO'),
                _value('-', bold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTypeAndKeyInfo() {
    return pw.Column(
      children: [
        _box(
          padding: pw.EdgeInsets.zero,
          child: pw.Row(
            children: [
              pw.Expanded(
                  child: _cell(children: [
                _label('TIPO DO CTE'),
                _value(data.tipoCte, bold: true)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('TIPO DO SERVIÇO'),
                _value(data.tipoServico, bold: true)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    _label('CHAVE DE ACESSO'),
                    pw.Container(
                      height: 30,
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: data.chaveAcesso
                              .replaceAll('.', '')
                              .replaceAll('-', ''),
                          drawText: false),
                    ),
                    pw.Text(data.chaveAcesso,
                        style: pw.TextStyle(
                            fontSize: 7, font: pw.Font.courierBold())),
                  ],
                ),
              ),
            ],
          ),
        ),
        _box(
          height: 30,
          child: pw.Center(
            child: _value(
                'Consulta de autenticidade no portal nacional do CT-e, no site da Sefaz Autorizadora,\nou em http://www.cte.fazenda.gov.br',
                align: pw.TextAlign.center),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildNaturezaEProtocolo() {
    return pw.Row(
      children: [
        pw.Expanded(
            child: _box(
                height: 25,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('CFOP - NATUREZA DA PRESTAÇÃO'),
                      _value(data.naturezaOperacao, bold: true)
                    ]))),
        pw.Expanded(
            child: _box(
                height: 25,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('PROTOCOLO DE AUTORIZAÇÃO DE USO'),
                      _value(data.protocoloAutorizacao, bold: true)
                    ]))),
      ],
    );
  }

  pw.Widget _buildPrestacaoInfo() {
    return pw.Row(
      children: [
        pw.Expanded(
            child: _box(
                height: 22,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('INÍCIO DA PRESTAÇÃO'),
                      _value(data.inicioPrestacao, bold: true)
                    ]))),
        pw.Expanded(
            child: _box(
                height: 22,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('TÉRMINO DA PRESTAÇÃO'),
                      _value(data.fimPrestacao, bold: true)
                    ]))),
      ],
    );
  }

  pw.Widget _buildParticipanteSection(
      String l1, ParticipanteDacte? p1, String l2, ParticipanteDacte? p2) {
    return pw.Row(
      children: [
        pw.Expanded(child: _renderGranularParticipante(l1, p1)),
        pw.Expanded(child: _renderGranularParticipante(l2, p2)),
      ],
    );
  }

  pw.Widget _renderGranularParticipante(String label, ParticipanteDacte? p) {
    return _box(
      height: 62,
      padding: pw.EdgeInsets.zero,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.all(1),
              child: pw.Row(children: [
                _label(label),
                pw.Spacer(),
                _value(p?.nome ?? '', bold: true)
              ])),
          pw.Divider(height: 0, thickness: 0.5),
          _cell(children: [
            _label('ENDEREÇO'),
            _value(p != null ? '${p.logradouro}, ${p.numero}' : '')
          ]),
          pw.Divider(height: 0, thickness: 0.5),
          pw.Row(
            children: [
              pw.Expanded(
                  flex: 3,
                  child: _cell(children: [
                    _label('MUNICÍPIO'),
                    _value(p?.municipio ?? '')
                  ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child:
                      _cell(children: [_label('CEP'), _value(p?.cep ?? '')])),
            ],
          ),
          pw.Divider(height: 0, thickness: 0.5),
          pw.Row(
            children: [
              pw.Expanded(
                  flex: 2,
                  child: _cell(children: [
                    _label('CNPJ/CPF'),
                    _value(p?.cnpjCpf ?? '')
                  ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 2,
                  child: _cell(children: [
                    _label('INSCRIÇÃO ESTADUAL'),
                    _value(p?.ie ?? '')
                  ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child:
                      _cell(children: [_label('PAÍS'), _value(p?.pais ?? '')])),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTomadorFinal() {
    final p = data.tomador;
    return _box(
      height: 38,
      padding: pw.EdgeInsets.zero,
      child: pw.Row(
        children: [
          pw.Expanded(
              flex: 7,
              child: _cell(children: [
                _label('TOMADOR DO SERVIÇO'),
                _value(p?.nome ?? '', bold: true),
                _value(p != null ? '${p.logradouro}, ${p.numero}' : '')
              ])),
          pw.VerticalDivider(width: 1, color: PdfColors.black),
          pw.Expanded(
              flex: 2,
              child: _cell(
                  children: [_label('MUNICÍPIO'), _value(p?.municipio ?? '')])),
          pw.VerticalDivider(width: 1, color: PdfColors.black),
          pw.Expanded(
              child: _cell(children: [_label('UF'), _value(p?.uf ?? '')])),
          pw.VerticalDivider(width: 1, color: PdfColors.black),
          pw.Expanded(
              flex: 2,
              child: _cell(children: [_label('CEP'), _value(p?.cep ?? '')])),
        ],
      ),
    );
  }

  pw.Widget _buildCargaInfo() {
    return pw.Column(
      children: [
        _box(
          padding: pw.EdgeInsets.zero,
          child: pw.Row(
            children: [
              pw.Expanded(
                  flex: 4,
                  child: _cell(children: [
                    _label('PRODUTO PREDOMINANTE'),
                    _value(data.produtoPredominante, bold: true)
                  ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 2,
                  child: _cell(children: [
                    _label('OUTRAS CARACTERÍSTICAS DA CARGA'),
                    _value(data.outrasCaracteristicas, bold: true)
                  ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 2,
                  child: _cell(children: [
                    _label('VALOR TOTAL DA MERCADORIA'),
                    _value(_format(data.valorTotalCarga),
                        align: pw.TextAlign.right, bold: true)
                  ])),
            ],
          ),
        ),
        _box(
          padding: pw.EdgeInsets.zero,
          child: pw.Row(
            children: [
              pw.Expanded(
                  child: _cell(children: [
                _label('PESO DECLARADO'),
                _value(data.pesoDeclarado)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(
                      children: [_label('VOLUMES'), _value(data.volumes)])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('CUBAGEM (M3)'),
                _value(data.cubagem)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(
                      children: [_label('QTDE (VOL)'), _value(data.qtde)])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 4,
                  child: _cell(
                      children: [_label('NOME DA SEGURADORA'), _value('-')])),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildComponentesGrid() {
    return _box(
      padding: pw.EdgeInsets.zero,
      child: pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            color: PdfColors.grey100,
            padding: const pw.EdgeInsets.symmetric(vertical: 1),
            child: pw.Center(
                child: _label('COMPONENTES DO VALOR DA PRESTAÇÃO DO SERVIÇO')),
          ),
          pw.Divider(height: 0, thickness: 0.5),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 8,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Wrap(
                    spacing: 10,
                    runSpacing: 2,
                    children: data.componentes
                        .map((c) => pw.Container(
                            width: 120,
                            child: pw.Row(children: [
                              _value(c.nome,
                                  bold: true, align: pw.TextAlign.left),
                              pw.Spacer(),
                              _value(c.valor, align: pw.TextAlign.right)
                            ])))
                        .toList(),
                  ),
                ),
              ),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    _cell(children: [
                      _label('VALOR TOTAL DO SERVIÇO'),
                      _value(_format(data.valorTotalServico),
                          bold: true, align: pw.TextAlign.right)
                    ]),
                    pw.Divider(height: 0, thickness: 0.5),
                    _cell(children: [
                      _label('VALOR A RECEBER'),
                      _value(_format(data.valorReceber),
                          bold: true, align: pw.TextAlign.right)
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildImpostoInfo() {
    return _box(
      padding: pw.EdgeInsets.zero,
      child: pw.Column(
        children: [
          pw.Container(
              width: double.infinity,
              color: PdfColors.grey100,
              padding: const pw.EdgeInsets.symmetric(vertical: 1),
              child:
                  pw.Center(child: _label('INFORMAÇÕES RELATIVAS AO IMPOSTO'))),
          pw.Divider(height: 0, thickness: 0.5),
          pw.Row(
            children: [
              pw.Expanded(
                  flex: 3,
                  child: _cell(children: [
                    _label('SITUAÇÃO TRIBUTÁRIA'),
                    _value(data.situacaoTributaria)
                  ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('BASE DE CALCULO'),
                _value(_format(data.baseIcms), align: pw.TextAlign.right)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('ALÍQ ICMS'),
                _value(_format(data.aliqIcms), align: pw.TextAlign.right)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('VALOR ICMS'),
                _value(_format(data.valorIcms), align: pw.TextAlign.right)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('% RED. BC ICMS'),
                _value(_format(data.redBcIcms), align: pw.TextAlign.right)
              ])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  child: _cell(children: [
                _label('ICMS ST'),
                _value(_format(data.icmsSt), align: pw.TextAlign.right)
              ])),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDocumentosOriginarios() {
    return _box(
      padding: pw.EdgeInsets.zero,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
              width: double.infinity,
              color: PdfColors.grey100,
              padding: const pw.EdgeInsets.symmetric(vertical: 1),
              child: pw.Center(child: _label('DOCUMENTOS ORIGINÁRIOS'))),
          pw.Divider(height: 0, thickness: 0.5),
          pw.Row(
            children: [
              pw.Expanded(
                  flex: 2, child: _cell(children: [_label('TIPO DOC')])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 4, child: _cell(children: [_label('CNPJ/CHAVE')])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 3,
                  child: _cell(children: [_label('SÉRIE/NRO. DOCUMENTO')])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 2, child: _cell(children: [_label('TIPO DOC')])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 4, child: _cell(children: [_label('CNPJ/CHAVE')])),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                  flex: 3,
                  child: _cell(children: [_label('SÉRIE/NRO. DOCUMENTO')])),
            ],
          ),
          pw.Divider(height: 0, thickness: 0.5),
          pw.Container(
            height: 80,
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: data.documentosOriginarios
                        .map((d) => pw.Row(
                              children: [
                                pw.Expanded(
                                    flex: 2,
                                    child: _cell(children: [_value(d.tipo)])),
                                pw.Expanded(
                                    flex: 4,
                                    child:
                                        _cell(children: [_value(d.cnpjChave)])),
                                pw.Expanded(
                                    flex: 3,
                                    child:
                                        _cell(children: [_value(d.serieNro)])),
                              ],
                            ))
                        .toList(),
                  ),
                ),
                pw.VerticalDivider(width: 1, color: PdfColors.black),
                pw.Expanded(child: pw.SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildObservacoes() {
    return _box(
      height: 60,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _label('OBSERVAÇÕES'),
          _value(data.observacoes, bold: false),
        ],
      ),
    );
  }

  pw.Widget _buildDadosModal() {
    return pw.Column(
      children: [
        _box(
          padding: pw.EdgeInsets.zero,
          child: pw.Column(
            children: [
              pw.Container(
                  width: double.infinity,
                  color: PdfColors.grey100,
                  padding: const pw.EdgeInsets.symmetric(vertical: 1),
                  child: pw.Center(
                      child: _label(
                          'DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA'))),
              pw.Divider(height: 0, thickness: 0.5),
              pw.Row(
                children: [
                  pw.Expanded(
                      child: _cell(children: [
                    _label('RNTRC DA EMPRESA'),
                    _value(data.rntrc, bold: true)
                  ])),
                  pw.VerticalDivider(width: 1, color: PdfColors.black),
                  pw.Expanded(
                      child: _cell(children: [
                    _label('CIOT'),
                    _value(data.ciot, bold: true)
                  ])),
                  pw.VerticalDivider(width: 1, color: PdfColors.black),
                  pw.Expanded(
                      child: _cell(children: [
                    _label('DATA PREVISTA DE ENTREGA'),
                    _value(data.dataPrevistaEntrega, bold: true)
                  ])),
                  pw.VerticalDivider(width: 1, color: PdfColors.black),
                  pw.Expanded(
                      flex: 2,
                      child: _box(
                          child: pw.Center(
                              child: pw.Text(
                                  'ESTE CONHECIMENTO DE TRANSPORTE ATENDE\nÀ LEGISLAÇÃO DE TRANSPORTE RODOVIÁRIO EM VIGOR',
                                  style: pw.TextStyle(
                                      fontSize: 5,
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.center)),
                          height: 25,
                          padding: pw.EdgeInsets.zero)),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Row(
          children: [
            pw.Expanded(
                child: _box(
                    height: 35,
                    child: pw.Center(
                        child: _label('USO EXCLUSIVO DO EMISSOR DO CT-E')))),
            pw.SizedBox(width: 2),
            pw.Expanded(
                child: _box(
                    height: 35,
                    child: pw.Center(child: _label('RESERVADO AO FISCO')))),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooterNote() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
              'Impresso em ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 4)),
          pw.Text('Gerado em www.fsist.com.br',
              style: pw.TextStyle(fontSize: 4)),
        ],
      ),
    );
  }
}
