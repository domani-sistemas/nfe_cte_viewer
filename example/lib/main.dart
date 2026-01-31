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
      chaveAcesso: '35231012345678000199570010000004561000004567',
      numero: '456',
      serie: '1',
      modelo: '57',
      naturezaOperacao: 'PRESTACAO DE SERVICO DE TRANSPORTE',
      protocoloAutorizacao: '135230007654321',
      dataEmissao: DateTime.now(),
      municipioOrigem: 'SAO PAULO',
      ufOrigem: 'SP',
      municipioDestino: 'RIO DE JANEIRO',
      ufDestino: 'RJ',
      emitente: const Participante(
        nome: 'TRANSPORTADORA OFICIAL LTDA',
        cnpj: '11.111.111/0001-11',
        ie: '111222333',
        enderecoLogradouro: 'RUA DA CARGA',
        enderecoNumero: '500',
        enderecoBairro: 'LOGISTICA',
        enderecoMunicipio: 'SAO PAULO',
        enderecoUf: 'SP',
        enderecoCep: '05000-000',
      ),
      remetente: const Participante(
        nome: 'FABRICA DE MOVEIS SA',
        cnpj: '22.222.222/0001-22',
        enderecoLogradouro: 'AV INDUSTRIAL',
        enderecoNumero: '1000',
        enderecoMunicipio: 'SAO PAULO',
        enderecoUf: 'SP',
      ),
      destinatario: const Participante(
        nome: 'LOJA DE DECORACAO LTDA',
        cnpj: '33.333.333/0001-33',
        enderecoLogradouro: 'RUA DO COMERCIO',
        enderecoNumero: '50',
        enderecoMunicipio: 'RIO DE JANEIRO',
        enderecoUf: 'RJ',
      ),
      tomador: const Participante(
        nome: 'FABRICA DE MOVEIS SA',
        cnpj: '22.222.222/0001-22',
        enderecoLogradouro: 'AV INDUSTRIAL',
        enderecoNumero: '1000',
        enderecoMunicipio: 'SAO PAULO',
        enderecoUf: 'SP',
      ),
      transporte: const Transporte(
        modFrete: '0',
        volEspecie: 'MOVEIS',
        pesoBruto: 1200.0,
      ),
      valorTotalProdutos: 15000.0, // Valor da carga
      valorPrestacao: 850.0,
      valorReceber: 850.0,
      totaisImpostos: const Impostos(vbc: 850.0, vicms: 102.0),
    );

    return await DacteSefazPrinter(DacteMapper.fromDomain(doc)).generate();
  }
}
