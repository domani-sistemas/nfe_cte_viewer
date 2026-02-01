import 'package:flutter/material.dart';
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiscal PDF Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ignore: prefer_final_fields
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Fiscal PDF Suite',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF01579B)],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Suíte de Visualização Fiscal',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      _buildSectionHeader('Demonstrações (Memória)'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDocCard(
                              context,
                              title: 'NF-e',
                              subtitle: 'Exemplo em Memória',
                              icon: Icons.inventory_2_outlined,
                              color: Colors.orange.shade700,
                              onTap: () =>
                                  _showPdf(context, _generateDanfeMemory()),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDocCard(
                              context,
                              title: 'CT-e',
                              subtitle: 'Exemplo em Memória',
                              icon: Icons.local_shipping_outlined,
                              color: Colors.green.shade700,
                              onTap: () =>
                                  _showPdf(context, _generateDacteMemory()),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDocCard(
                              context,
                              title: 'NFC-e',
                              subtitle: 'Cupom Eletrônico',
                              icon: Icons.receipt_long_outlined,
                              color: Colors.purple.shade700,
                              onTap: () =>
                                  _showPdf(context, _generateNfceMemory()),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                      _buildSectionHeader('Documentos Reais (XML)'),
                      const SizedBox(height: 16),
                      _buildListTile(
                        context,
                        title: 'Carregar XML Local',
                        subtitle: 'Detector automático NF-e / CT-e',
                        icon: Icons.file_upload_outlined,
                        color: Colors.blue.shade400,
                        onTap: _pickAndLoadXml,
                      ),
                      const SizedBox(height: 12),
                      _buildListTile(
                        context,
                        title: 'Visualizar XML Exemplo (NF-e)',
                        subtitle: 'Processamento de arquivo real',
                        icon: Icons.description_outlined,
                        color: Colors.orange.shade400,
                        onTap: () => _loadSampleXml('nfe'),
                      ),
                      const SizedBox(height: 12),
                      _buildListTile(
                        context,
                        title: 'Visualizar XML Exemplo (CT-e)',
                        subtitle: 'Processamento de arquivo real',
                        icon: Icons.description_outlined,
                        color: Colors.green.shade400,
                        onTap: () => _loadSampleXml('cte'),
                      ),
                      const SizedBox(height: 12),
                      _buildListTile(
                        context,
                        title: 'Visualizar XML Exemplo (NFC-e)',
                        subtitle: 'Cupom em arquivo real',
                        icon: Icons.receipt_long_outlined,
                        color: Colors.purple.shade400,
                        onTap: () => _loadSampleXml('nfce'),
                      ),

                      const SizedBox(height: 60),
                      const Text(
                        'Domani Sistemas - Excelência Fiscal',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildDocCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withAlpha(25),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withAlpha(15),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white30),
            ],
          ),
        ),
      ),
    );
  }

  void _showPdf(BuildContext context, Future<Uint8List> pdfFuture) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Visualização do Documento')),
          body: PdfPreview(build: (format) => pdfFuture, canDebug: false),
        ),
      ),
    );
  }

  Future<void> _pickAndLoadXml() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
        withData: true,
      );

      if (result == null) return;

      setState(() => _isLoading = true);

      String? xml;
      final file = result.files.single;

      if (file.bytes != null) {
        xml = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        xml = await File(file.path!).readAsString();
      }

      if (xml != null) {
        _processXml(xml);
      } else {
        throw 'Não foi possível ler o conteúdo do arquivo.';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar arquivo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loadSampleXml(String type) {
    String xml = '';
    if (type == 'nfe') {
      xml =
          r'''<nfeProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe><infNFe Id="NFe29251126935422000142550020001850531131148660" versao="4.00"><ide><cUF>29</cUF><cNF>13114866</cNF><natOp>VENDA</natOp><mod>55</mod><serie>2</serie><nNF>185053</nNF><dhEmi>2025-11-07T14:12:00-03:00</dhEmi><tpNF>1</tpNF><idDest>1</idDest><cMunFG>2910800</cMunFG><tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>0</cDV><tpAmb>1</tpAmb><finNFe>1</finNFe><indFinal>0</indFinal><indPres>9</indPres><indIntermed>1</indIntermed><procEmi>0</procEmi><verProc>2.4.0</verProc></ide><emit><CNPJ>26935422000142</CNPJ><xNome>NORTE DISTRIBUIDORA LTDA</xNome><enderEmit><xLgr>AV EDUARDO FROES DA MOTA</xLgr><nro>2221</nro><xBairro>CONCEICAO</xBairro><cMun>2910800</cMun><xMun>FEIRA DE SANTANA</xMun><UF>BA</UF><CEP>44065175</CEP></enderEmit><IE>150303729</IE><CRT>3</CRT></emit><dest><CNPJ>40511347000113</CNPJ><xNome>PABLO ALAN</xNome><enderDest><xLgr>RUA DOUTOR SIMOES FILHO</xLgr><nro>525</nro><xBairro>PONTO CENTRAL</xBairro><cMun>2910800</cMun><xMun>FEIRA DE SANTANA</xMun><UF>BA</UF><CEP>44100000</CEP></enderDest><IE>60667260</IE></dest><det nItem="1"><prod><cProd>104302</cProd><xProd>COPO AMERICANO DOSE 45ML</xProd><NCM>70133700</NCM><CFOP>5102</CFOP><uCom>UN</uCom><qCom>24.0000</qCom><vUnCom>2.30</vUnCom><vProd>55.20</vProd><indTot>1</indTot></prod><imposto><ICMS><ICMS20><orig>0</orig><CST>20</CST><vBC>32.47</vBC><pICMS>20.50</pICMS><vICMS>6.66</vICMS></ICMS20></ICMS></imposto></det><total><ICMStot><vBC>32.47</vBC><vICMS>6.66</vICMS><vBCST>0.00</vBCST><vST>0.00</vST><vProd>500.00</vProd><vNF>500.00</vNF></ICMStot></total><transp><modFrete>0</modFrete></transp></infNFe></NFe></nfeProc>''';
    } else if (type == 'cte') {
      xml =
          r'''<cteProc versao="4.00" xmlns="http://www.portalfiscal.inf.br/cte"><CTe xmlns="http://www.portalfiscal.inf.br/cte"><infCte versao="4.00" Id="CTe35250810973773000108570020001084611007902407"><ide><cUF>35</cUF><cCT>00790240</cCT><natOp>PRESTACAO SERVICO</natOp><mod>57</mod><serie>2</serie><nCT>108461</nCT><dhEmi>2025-08-14T13:50:00-03:00</dhEmi><modal>01</modal><xMunIni>GUARULHOS</xMunIni><UFIni>SP</UFIni><xMunFim>FEIRA DE SANTANA</xMunFim><UFFim>BA</UFFim></ide><emit><CNPJ>10973773000108</CNPJ><xNome>TRANSPORTADORA EXEMPLO</xNome><enderEmit><xLgr>RUA OURO VERDE</xLgr><nro>1233</nro><xMun>GUARULHOS</xMun><UF>SP</UF></enderEmit><IE>336889818111</IE></emit><rem><CNPJ>02841705000167</CNPJ><xNome>REMETENTE ABC</xNome><enderReme><xLgr>RUA DO ORFANATO</xLgr><xMun>SAO PAULO</xMun><UF>SP</UF></enderReme></rem><dest><CNPJ>07754759000109</CNPJ><xNome>DESTINATARIO XYZ</xNome><enderDest><xLgr>RUA RIO DE CONTAS</xLgr><xMun>FEIRA DE SANTANA</xMun><UF>BA</UF></enderDest></dest><vPrest><vTPrest>256.99</vTPrest><vRec>256.99</vRec><Comp><xNome>FRETE PESO</xNome><vComp>150.00</vComp></Comp></vPrest><imp><ICMS><ICMS00><vBC>256.99</vBC><vICMS>17.99</vICMS></ICMS00></ICMS></imp><infCTeNorm><infCarga><vCarga>5400.00</vCarga><proPred>TACHO INOX</proPred><infQ><tpMed>PESO BRUTO</tpMed><qCarga>45.0000</qCarga><cUnid>01</cUnid></infQ></infCarga><infModal><rodo><RNTRC>12175427</RNTRC></rodo></infModal></infCTeNorm></infCte></CTe></cteProc>''';
    } else if (type == 'nfce') {
      xml =
          r'''<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><NFe><infNFe Id="NFe29251126935422000142650020001850531131148660" versao="4.00"><ide><cUF>29</cUF><cNF>13114866</cNF><natOp>VENDA</natOp><mod>65</mod><serie>2</serie><nNF>185053</nNF><dhEmi>2025-11-07T14:12:00-03:00</dhEmi><tpAmb>2</tpAmb></ide><emit><CNPJ>26935422000142</CNPJ><xNome>MERCADO CENTRAL LTDA</xNome><enderEmit><xLgr>RUA DAS FLORES</xLgr><nro>100</nro><xBairro>CENTRO</xBairro><xMun>FEIRA DE SANTANA</xMun><UF>BA</UF></enderEmit></emit><det nItem="1"><prod><cProd>001</cProd><xProd>REFRIGERANTE LATA</xProd><uCom>UN</uCom><qCom>2.0000</qCom><vUnCom>5.00</vUnCom><vProd>10.00</vProd></prod></det><total><ICMStot><vProd>10.00</vProd><vNF>10.00</vNF></ICMStot></total><pag><detPag><tPag>01</tPag><vPag>10.00</vPag></detPag></pag></infNFe><infNFeSupl><qrCode>https://www.sefaz.ba.gov.br/nfce/qrcode?p=29251126935422000142650020001850531131148660|2|1|1|6C8B5</qrCode><urlChave>https://www.sefaz.ba.gov.br/nfce/consulta</urlChave></infNFeSupl></NFe></nfeProc>''';
    }
    _processXml(xml);
  }

  Future<void> _processXml(String xml) async {
    try {
      final doc = FiscalParser.parse(xml);
      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      if (doc.isCte) {
        _showPdf(
          context,
          Future.value(
            DacteSefazPrinter(
              DacteMapper.fromDomain(doc),
              font: font,
              fontBold: fontBold,
            ).generate(),
          ),
        );
      } else if (doc.isNfce) {
        _showPdf(
          context,
          Future.value(
            NfceSefazPrinter(
              NfceMapper.fromDomain(doc),
              font: font,
              fontBold: fontBold,
            ).generate(),
          ),
        );
      } else {
        _showPdf(
          context,
          Future.value(
            DanfeSefazPrinter(
              DanfeMapper.fromDomain(doc),
              font: font,
              fontBold: fontBold,
            ).generate(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar XML: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Uint8List> _generateDanfeMemory() async {
    final doc = DocumentoFiscal(
      chaveAcesso: '35231012345678000199550010000001231000001234',
      numero: '123',
      serie: '1',
      naturezaOperacao: 'VENDA DE MERCADORIA',
      protocoloAutorizacao: '135230001234567',
      dataEmissao: DateTime.now(),
      emitente: const Participante(
        nome: 'EMPRESA TESTE LTDA',
        cnpj: '12.345.678/0001-99',
        ie: '123456789',
        enderecoLogradouro: 'RUA DOS EXEMPLOS',
        enderecoNumero: '1000',
        enderecoBairro: 'CENTRO',
        enderecoMunicipio: 'SAO PAULO',
        enderecoUf: 'SP',
        enderecoCep: '01000-000',
        enderecoTelefone: '(11) 9999-9999',
      ),
      destinatario: const Participante(
        nome: 'CLIENTE EXEMPLO SA',
        cnpj: '98.765.432/0001-00',
        ie: '987654321',
        enderecoLogradouro: 'AVENIDA DO CLIENTE',
        enderecoNumero: '200',
        enderecoBairro: 'INDUSTRIAL',
        enderecoMunicipio: 'CURITIBA',
        enderecoUf: 'PR',
        enderecoCep: '80000-000',
      ),
      itens: [
        const ItemDocumentoFiscal(
          codigo: '001',
          descricao: 'PRODUTO DE TESTE 1',
          quantidade: 10,
          valorUnitario: 50.0,
          valorTotal: 500.0,
        ),
      ],
      transporte: const Transporte(
        modFrete: '0',
        transportadoraNome: 'TRANS VELOZ',
        veiculoPlaca: 'ABC-1234',
        valorFrete: 50.0,
      ),
      valorTotalProdutos: 500.0,
      valorTotalNota: 550.0,
    );

    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    return await DanfeSefazPrinter(
      DanfeMapper.fromDomain(doc),
      font: font,
      fontBold: fontBold,
    ).generate();
  }

  Future<Uint8List> _generateDacteMemory() async {
    final doc = DocumentoFiscal(
      isCte: true,
      chaveAcesso: '29251157650695000174570010000000571000000571',
      numero: '57',
      serie: '1',
      modelo: '57',
      naturezaOperacao: '6353 - TRANSP. P/ ESTAB. CIAL',
      protocoloAutorizacao: '329250210137626 - 11/11/2025 10:47:02',
      dataEmissao: DateTime(2025, 11, 11),
      municipioOrigem: 'FEIRA DE SANTANA',
      ufOrigem: 'BA',
      municipioDestino: 'BRASILIA',
      ufDestino: 'DF',
      emitente: const Participante(
        nome: 'ASTECA TRANSPORTES LTDA',
        cnpj: '57.650.695/0001-74',
        ie: '223351996',
        enderecoLogradouro: 'MANOEL DA COSTA FALCAO',
        enderecoNumero: '2047',
        enderecoBairro: 'CIS TOMBA',
        enderecoMunicipio: 'FEIRA DE SANTANA',
        enderecoUf: 'BA',
        enderecoCep: '44010-025',
      ),
      remetente: const Participante(
        nome: 'NOVA FATIMA IND E COM DE MAT DE CONTRUCAO',
        cnpj: '05.943.421/0001-70',
        ie: '62602411',
        enderecoLogradouro: 'AV SUDENE',
        enderecoNumero: '2047',
        enderecoMunicipio: 'FEIRA DE SANTANA',
        enderecoUf: 'BA',
        enderecoCep: '44063-640',
        enderecoTelefone: '(75) 3622-1332',
      ),
      destinatario: const Participante(
        nome: 'R13 RIACHO FUNDO II COMERCIO',
        cnpj: '54.441.532/0001-93',
        ie: '0828818500175',
        enderecoLogradouro: 'Q QS 31 CONJUNTO 3,1',
        enderecoBairro: 'RIACHO FUNDO II',
        enderecoMunicipio: 'BRASILIA',
        enderecoUf: 'DF',
        enderecoCep: '71884-841',
      ),
      tomador: const Participante(
        nome: 'NOVA FATIMA IND E COM DE MAT DE CONTRUCAO',
        cnpj: '05.943.421/0001-70',
        ie: '62602411',
        enderecoLogradouro: 'AV SUDENE',
        enderecoNumero: '2047',
        enderecoMunicipio: 'FEIRA DE SANTANA',
        enderecoUf: 'BA',
        enderecoCep: '44063-640',
      ),
      transporte: const Transporte(
        modFrete: '0',
        volEspecie: 'TESTEIRA LUMINOSA',
        volMarca: 'ESPECIE',
        pesoBruto: 2900.0,
        volQuantidade: '0',
        veiculoRntrc: '57396444',
        ciot: '123456',
        valorFrete: 3000.0,
      ),
      valorTotalProdutos: 44550.0, // Valor da carga
      valorPrestacao: 3000.0,
      valorReceber: 3000.0,
      totaisImpostos: const Impostos(vbc: 0.0, vicms: 0.0),
      documentosOriginarios: [
        const DocumentoOriginarioCte(
          tipo: 'NF-e',
          chave: '29251105943421000170550010000028901491146634',
        ),
      ],
      informacoesComplementares:
          r'Lei Transparencia, Valor Aprox. Trib. R$300.00 EMPRESA OPTANTE PELO SIMPLES NACIONAL',
    );

    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    return await DacteSefazPrinter(
      DacteMapper.fromDomain(doc),
      font: font,
      fontBold: fontBold,
    ).generate();
  }

  Future<Uint8List> _generateNfceMemory() async {
    final doc = DocumentoFiscal(
      modelo: '65',
      chaveAcesso: '29251126935422000142650020001850531131148660',
      numero: '185053',
      serie: '2',
      dataEmissao: DateTime.now(),
      protocoloAutorizacao: '129250001234567',
      urlConsulta: 'www.sefaz.ba.gov.br/nfce/consulta',
      qrCode: 'https://www.sefaz.ba.gov.br/nfce/qrcode?p=...',
      tipoAmbiente: '2',
      emitente: const Participante(
        nome: 'MERCADO CENTRAL LTDA',
        cnpj: '26.935.422/0001-42',
        enderecoLogradouro: 'RUA DAS FLORES',
        enderecoNumero: '100',
        enderecoBairro: 'CENTRO',
        enderecoMunicipio: 'FEIRA DE SANTANA',
        enderecoUf: 'BA',
      ),
      itens: [
        const ItemDocumentoFiscal(
          codigo: '101',
          descricao: 'CERVEJA LATA 350ML',
          quantidade: 12,
          unidade: 'UN',
          valorUnitario: 4.50,
          valorTotal: 54.0,
        ),
      ],
      pagamentos: [const PagamentoDocumento(forma: '01', valor: 54.0)],
      valorTotalProdutos: 54.0,
      valorTotalNota: 54.0,
    );

    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    return await NfceSefazPrinter(
      NfceMapper.fromDomain(doc),
      font: font,
      fontBold: fontBold,
    ).generate();
  }
}
