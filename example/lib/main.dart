import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fiscal Viewer Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fiscal Viewer Preview'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'DANFE (NF-e)', icon: Icon(Icons.description)),
              Tab(text: 'DACTE (CT-e)', icon: Icon(Icons.local_shipping)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FiscalPdfPreview(tipo: 'NFE'),
            FiscalPdfPreview(tipo: 'CTE'),
          ],
        ),
      ),
    );
  }
}

class FiscalPdfPreview extends StatelessWidget {
  final String tipo;
  const FiscalPdfPreview({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) => tipo == 'NFE' ? _generateDanfe() : _generateDacte(),
      canChangePageFormat: false,
      canChangeOrientation: false,
      canDebug: false,
    );
  }

  Future<Uint8List> _generateDanfe() async {
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
        ItemDocumentoFiscal(
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

    return await DanfeSefazPrinter(DanfeMapper.fromDomain(doc)).generate();
  }

  Future<Uint8List> _generateDacte() async {
    final doc = DocumentoFiscal(
      chaveAcesso: '29251157650695000174570010000000571000000571',
      numero: '57',
      serie: '1',
      modelo: '57',
      naturezaOperacao: '6353 - TRANSP. P/ ESTAB. CIAL',
      protocoloAutorizacao: '329250210137626 - 11/11/2025 10:47:02',
      dataEmissao: DateTime(2025, 11, 11),
      tipoCte: 'Normal',
      tipoServico: 'Normal',
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
      documentosOriginarios: ['29251105943421000170550010000028901491146634'],
      informacoesComplementares:
          'Lei Transparencia, Valor Aprox. Trib. R\$300.00 EMPRESA OPTANTE PELO SIMPLES NACIONAL',
    );

    return await DacteSefazPrinter(DacteMapper.fromDomain(doc)).generate();
  }
}
