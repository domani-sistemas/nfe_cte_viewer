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
          _buildCanhoto(),
          pw.SizedBox(height: 2),
          _buildHeader(),
          pw.SizedBox(height: 2),
          _buildCteInfo(),
          pw.SizedBox(height: 2),
          _buildNaturezaEProtocolo(),
          pw.SizedBox(height: 2),
          _buildPrestacaoInfo(),
          pw.SizedBox(height: 2),
          _buildParticipantes(),
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
      pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);

  pw.Widget _box(
      {required pw.Widget child,
      double? height,
      double? width,
      pw.EdgeInsets? padding}) {
    return pw.Container(
      height: height,
      width: width,
      padding: padding ?? const pw.EdgeInsets.all(1.5),
      decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black, width: 0.5)),
      child: child,
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
      height: 45,
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 8,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _value(
                    'DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE',
                    bold: false),
                pw.Spacer(),
                pw.Row(
                  children: [
                    pw.Expanded(
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
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              children: [
                _label('TÉRMINO DA PRESTAÇÃO - DATA/HORA'),
                pw.Divider(thickness: 0.5),
                _label('INÍCIO DA PRESTAÇÃO - DATA/HORA'),
              ],
            ),
          ),
          _box(
            width: 80,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _value('CT-E', bold: true),
                _label('Nº. DOCUMENTO ${data.numero}'),
                _label('SÉRIE ${data.serie}'),
              ],
            ),
          ),
        ],
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
            height: 80,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(data.emitente.nome,
                    style: _titleStyle, textAlign: pw.TextAlign.center),
                _value(data.emitente.enderecoCompleto,
                    align: pw.TextAlign.center),
                _value(
                    'CNPJ/CPF: ${data.emitente.cnpjCpf}  Insc.Estadual: ${data.emitente.ie}',
                    align: pw.TextAlign.center),
              ],
            ),
          ),
        ),
        pw.Expanded(
          flex: 30,
          child: _box(
            height: 80,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('DACTE',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10)),
                _value('Documento Auxiliar do Conhecimento',
                    align: pw.TextAlign.center),
                _value('de Transporte Eletrônico', align: pw.TextAlign.center),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(children: [
                      _label('MODELO'),
                      _value(data.modelo, bold: true)
                    ]),
                    pw.Column(children: [
                      _label('SÉRIE'),
                      _value(data.serie, bold: true)
                    ]),
                    pw.Column(children: [
                      _label('NÚMERO'),
                      _value(data.numero, bold: true)
                    ]),
                    pw.Column(
                        children: [_label('FL'), _value('1/1', bold: true)]),
                  ],
                ),
              ],
            ),
          ),
        ),
        pw.Expanded(
          flex: 30,
          child: _box(
            height: 80,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _value('MODAL', bold: true),
                pw.Text('Rodoviário',
                    style: _valueBoldStyle.copyWith(fontSize: 10)),
                pw.Divider(thickness: 0.5),
                _label('DATA E HORA DE EMISSÃO'),
                _value(data.dataEmissao, bold: true),
                _label('INSC. SUFRAMA DO DESTINATÁRIO'),
                _value('-'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildCteInfo() {
    return pw.Row(
      children: [
        pw.Expanded(
            child: _box(
                height: 30,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('TIPO DO CTE'),
                      _value(data.tipoCte, bold: true)
                    ]))),
        pw.Expanded(
            child: _box(
                height: 30,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('TIPO DO SERVIÇO'),
                      _value(data.tipoServico, bold: true)
                    ]))),
        pw.Expanded(
            flex: 2,
            child: _box(
                height: 30,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('CHAVE DE ACESSO'),
                      _value(data.chaveAcesso, bold: true)
                    ]))),
      ],
    );
  }

  pw.Widget _buildNaturezaEProtocolo() {
    return pw.Row(
      children: [
        pw.Expanded(
            child: _box(
                height: 30,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('CFOP - NATUREZA DA PRESTAÇÃO'),
                      _value(data.naturezaOperacao, bold: true)
                    ]))),
        pw.Expanded(
            child: _box(
                height: 30,
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
                height: 25,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('INÍCIO DA PRESTAÇÃO'),
                      _value(data.inicioPrestacao, bold: true)
                    ]))),
        pw.Expanded(
            child: _box(
                height: 25,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _label('TÉRMINO DA PRESTAÇÃO'),
                      _value(data.fimPrestacao, bold: true)
                    ]))),
      ],
    );
  }

  pw.Widget _buildParticipantes() {
    return pw.Column(
      children: [
        pw.Row(children: [
          pw.Expanded(child: _renderParticipante('REMETENTE', data.remetente)),
          pw.Expanded(
              child: _renderParticipante('DESTINATÁRIO', data.destinatario))
        ]),
        pw.Row(children: [
          pw.Expanded(child: _renderParticipante('EXPEDIDOR', data.expedidor)),
          pw.Expanded(child: _renderParticipante('RECEBEDOR', data.recebedor))
        ]),
      ],
    );
  }

  pw.Widget _renderParticipante(String label, ParticipanteDacte? p) {
    return _box(
      height: 55,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(children: [
            _label(label),
            pw.Spacer(),
            _value(p?.nome ?? '', bold: true)
          ]),
          _label('ENDEREÇO'),
          _value('${p?.logradouro ?? ''}, ${p?.numero ?? ''}'),
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('MUNICÍPIO'),
                    _value(p?.municipio ?? '')
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [_label('CEP'), _value(p?.cep ?? '')])),
            ],
          ),
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('CNPJ/CPF'),
                    _value(p?.cnpjCpf ?? '')
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('INSCRIÇÃO ESTADUAL'),
                    _value(p?.ie ?? '')
                  ])),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTomadorFinal() {
    final p = data.tomador;
    return _box(
      height: 40,
      child: pw.Row(
        children: [
          pw.Expanded(
              flex: 3,
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('TOMADOR DO SERVIÇO'),
                    _value(p?.nome ?? '', bold: true),
                    _value(p?.enderecoCompleto ?? '')
                  ])),
          pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('MUNICÍPIO'), _value(p?.municipio ?? '')])),
          pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('UF'), _value(p?.uf ?? '')])),
          pw.Expanded(
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('CEP'), _value(p?.cep ?? '')])),
        ],
      ),
    );
  }

  pw.Widget _buildCargaInfo() {
    return pw.Column(
      children: [
        _box(
          child: pw.Row(
            children: [
              pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _label('PRODUTO PREDOMINANTE'),
                        _value(data.produtoPredominante, bold: true)
                      ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('OUTRAS CARACTERÍSTICAS DA CARGA'),
                    _value(data.outrasCaracteristicas, bold: true)
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('VALOR TOTAL DA MERCADORIA'),
                    _value(_format(data.valorTotalCarga),
                        align: pw.TextAlign.right, bold: true)
                  ])),
            ],
          ),
        ),
        _box(
          child: pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('PESO DECLARADO'),
                    _value(data.pesoDeclarado)
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [_label('VOLUMES'), _value(data.volumes)])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('CUBAGEM (M3)'),
                    _value(data.cubagem)
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [_label('QTDE (VOL)'), _value(data.qtde)])),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildComponentesGrid() {
    return _box(
      child: pw.Column(
        children: [
          _label('COMPONENTES DO VALOR DA PRESTAÇÃO DO SERVIÇO'),
          pw.Row(
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  children: data.componentes
                      .take(3)
                      .map((c) => pw.Row(children: [
                            _value(c.nome, bold: true),
                            pw.Spacer(),
                            _value(c.valor)
                          ]))
                      .toList(),
                ),
              ),
              pw.VerticalDivider(width: 1, color: PdfColors.black),
              pw.Expanded(
                child: pw.Column(
                  children: [
                    _label('VALOR TOTAL DO SERVIÇO'),
                    _value(_format(data.valorTotalServico),
                        bold: true, align: pw.TextAlign.right),
                    _label('VALOR A RECEBER'),
                    _value(_format(data.valorReceber),
                        bold: true, align: pw.TextAlign.right),
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
      child: pw.Column(
        children: [
          _label('INFORMAÇÕES RELATIVAS AO IMPOSTO'),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('SITUAÇÃO TRIBUTÁRIA'),
                    _value(data.situacaoTributaria)
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('BASE DE CALCULO'),
                    _value(_format(data.baseIcms))
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('ALÍQ ICMS'),
                    _value(_format(data.aliqIcms))
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('VALOR ICMS'),
                    _value(_format(data.valorIcms))
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('% RED. BC ICMS'),
                    _value(_format(data.redBcIcms))
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [_label('ICMS ST'), _value(_format(data.icmsSt))]),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDocumentosOriginarios() {
    return _box(
      height: 40,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _label('DOCUMENTOS ORIGINÁRIOS'),
          ...data.documentosOriginarios
              .map((d) => _value('${d.tipo}: ${d.cnpjChave}'))
              .toList(),
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
          _value(data.observacoes),
        ],
      ),
    );
  }

  pw.Widget _buildDadosModal() {
    return _box(
      child: pw.Column(
        children: [
          _label('DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA'),
          pw.Row(
            children: [
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('RNTRC DA EMPRESA'),
                    _value(data.rntrc)
                  ])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [_label('CIOT'), _value(data.ciot)])),
              pw.Expanded(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    _label('DATA PREVISTA DE ENTREGA'),
                    _value(data.dataPrevistaEntrega)
                  ])),
            ],
          ),
        ],
      ),
    );
  }
}
