# nfe_cte_viewer

Um pacote Flutter para geração de representações em PDF de documentos fiscais brasileiros (NFe, CTe, NFCe, e no futuro, CCe).

## Visão Geral

O `nfe_cte_viewer` é um pacote Flutter modular e reutilizável projetado para imprimir vários documentos fiscais em arquivos PDF. O pacote é autocontido e preparado para uma futura extração como um projeto independente.

A versão mais recente inclui implementações SEFAZ-compliant para geração de DANFE (NF-e) e DACTE (CT-e) que seguem os layouts oficiais aprovados pela SEFAZ, corrigindo problemas anteriores onde os documentos gerados não condiziam com as especificações oficiais. As implementações agora incluem:

- **Tipografia adequada**: Fontes Helvetica/Sans-Serif com tamanhos corretos (títulos: 6pt a 7pt, dados: 8pt a 9pt)
- **Margens padronizadas**: Margens de 1cm (10mm) conforme padrão SEFAZ
- **Preenchimento de página**: Lógica implementada para preencher a página com espaços vazios quando necessário
- **Código de barras**: Utiliza pw.BarcodeWidget com pw.Barcode.code128() para a Chave de Acesso (44 dígitos)
- **Layout adequado**: Documentos ocupam o tamanho mínimo de um papel A4 com posicionamento correto do rodapé

## Características

- **Desacoplamento Total**: O pacote não se conecta diretamente a um banco de dados nem faz parse de arquivos XML. Opera exclusivamente com Data Classes (modelos de dados) em Dart puro.
- **Modelos de Dados Genéricos**: Estruturas de dados flexíveis que suportam diferentes tipos de documentos fiscais brasileiros.
- **Layout Fiel ao DANFE**: Implementação que segue o padrão visual do DANFE oficial.
- **Extensibilidade**: Arquitetura preparada para suportar múltiplos tipos de documentos fiscais.

## Instalação

dependencies:
  nfe_cte_viewer: ^0.1.0

```dart
import 'package:sped_viewer/sped_viewer.dart';
```

### Exemplo Básico

```dart
import 'package:sped_viewer/sped_viewer.dart';
import 'package:pdf/widgets.dart' as pw;

// Criar um documento fiscal de exemplo
final documento = DocumentoFiscal(
  id: 1,
  idEstabelecimento: 1,
  chaveAcesso: '12345678901234567890123456789012345678901234',
  tipoDocumento: 'NFE',
  modelo: '55',
  serie: '1',
  numeroDocumento: 123,
  dataEmissao: DateTime.now(),
  cfopPrincipal: 5101,
  tipoOperacao: 'S',
  emitente: Participante(
    cnpj: '12345678000195',
    nome: 'Empresa Exemplo Ltda',
    enderecoLogradouro: 'Rua Exemplo',
    enderecoNumero: '123',
    enderecoBairro: 'Centro',
    enderecoMunicipio: 'São Paulo',
    enderecoUf: 'SP',
  ),
  destinatario: Participante(
    cnpj: '98765432000195',
    nome: 'Cliente Exemplo SA',
    enderecoLogradouro: 'Av. Exemplo',
    enderecoNumero: '456',
    enderecoBairro: 'Comercial',
    enderecoMunicipio: 'Rio de Janeiro',
    enderecoUf: 'RJ',
  ),
  valorTotalNota: 1000.00,
  itens: [
    ItemDocumentoFiscal(
      id: 1,
      idDocumentoFiscal: 1,
      numeroItem: 1,
      descricaoProduto: 'Produto Exemplo',
      unidade: 'UN',
      quantidade: 10,
      valorUnitario: 100.00,
      valorTotalItem: 1000.00,
      cfop: 5101,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ],
  transporte: Transporte(
    modalidadeFrete: '0',
    nomeTransportador: 'Transportadora Exemplo',
    cnpjTransportador: '11222333000145',
    placaVeiculo: 'ABC1D23',
    ufVeiculo: 'SP',
  ),
  impostos: Impostos(
    valorIcms: 180.00,
    valorPis: 6.50,
    valorCofins: 30.00,
  ),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Gerar o PDF
final danfePrinter = DanfePrinter(documento);
final pdf = await danfePrinter.generate();

// Salvar ou exibir o PDF
List<int> bytes = await pdf.save();
```

## Modelos de Dados

O pacote inclui os seguintes modelos de dados:

- `DocumentoFiscal`: Representa um documento fiscal genérico (NFe, CTe, NFCe, etc.)
- `ItemDocumentoFiscal`: Representa um item no documento fiscal
- `Participante`: Representa emitente ou destinatário
- `Transporte`: Informações de transporte
- `Impostos`: Informações de impostos

## Impressoras Disponíveis

- `DanfePrinter`: Gera o DANFE para NF-e

## Contribuindo

Contribuições são bem-vindas! Por favor, siga estas etapas:

1. Faça um fork do projeto
2. Crie um branch para sua feature (`git checkout -b feature/NovaFeature`)
3. Faça commit das suas alterações (`git commit -m 'Adiciona NovaFeature'`)
4. Faça push para o branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob os termos da licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## Autores

- **Domani Fiscal** - Trabalho original