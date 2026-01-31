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
      title: 'Danfe Viewer Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DanfeViewerPage(),
    );
  }
}

class DanfeViewerPage extends StatelessWidget {
  const DanfeViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DANFE Preview')),
      body: PdfPreview(
        build: (format) => _generatePdf(),
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    // 1. Criar dados de exemplo (Domínio)
    final doc = DocumentoFiscal(
      chaveAcesso: '35231012345678000199550010000001231000001234',
      numero: '123',
      serie: '1',
      naturezaOperacao: 'VENDA DE MERCADORIA',
      protocoloAutorizacao: '135230001234567',
      dataEmissao: DateTime.now(),
      saida: true,
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
        enderecoTelefone: '(41) 8888-8888',
      ),
      itens: [
        ItemDocumentoFiscal(
          codigo: '001',
          descricao: 'PRODUTO DE TESTE AUTOMATIZADO 1',
          ncm: '12345678',
          cfop: '5102',
          cst: '000',
          unidade: 'UN',
          quantidade: 10,
          valorUnitario: 50.0,
          valorTotal: 500.0,
          impostos: const Impostos(vbc: 500.0, vicms: 90.0),
        ),
        ItemDocumentoFiscal(
          codigo: '002',
          descricao:
              'PRODUTO DE TESTE AUTOMATIZADO 2 COM LONGAS DESCRICOES PARA TESTE DE QUEBRA DE LINHA NO PDF',
          ncm: '87654321',
          cfop: '5102',
          cst: '000',
          unidade: 'PC',
          quantidade: 5,
          valorUnitario: 100.0,
          valorTotal: 500.0,
          impostos: const Impostos(vbc: 500.0, vicms: 90.0),
        ),
      ],
      transporte: const Transporte(
        modFrete: '0',
        transportadoraNome: 'TRANSPORTADORA VELOZ',
        transportadoraCnpj: '11.111.111/0001-11',
        veiculoPlaca: 'ABC-1234',
        veiculoUf: 'SP',
        volQuantidade: '15',
        volEspecie: 'CAIXAS',
        pesoBruto: 150.5,
        pesoLiquido: 145.0,
        valorFrete: 50.0,
      ),
      totaisImpostos: const Impostos(
        vbc: 1000.0,
        vicms: 180.0,
        vbcst: 0.0,
        vicmsst: 0.0,
        vipi: 0.0,
      ),
      valorTotalProdutos: 1000.0,
      valorTotalNota: 1050.0,
      informacoesComplementares:
          'DOCUMENTO GERADO PARA TESTES DO PACOTE NFE_CTE_VIEWER.',
    );

    // 2. Mapear para DanfeData
    final danfeData = DanfeMapper.fromDomain(doc);

    // 3. Gerar PDF
    final printer = DanfeSefazPrinter(danfeData);
    return await printer.generate();
  }
}
