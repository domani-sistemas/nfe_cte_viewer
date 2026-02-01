# nfe_cte_viewer 🚀

Um pacote Flutter de elite para geração de documentos fiscais brasileiros (NF-e, CT-e e NFC-e). Desenvolvido pela **Domani Sistemas** para oferecer fidelidade visual absoluta (Pixel Perfect) seguindo os manuais de integração da SEFAZ.

[![Pub Version](https://img.shields.io/pub/v/nfe_cte_viewer)](https://pub.dev/packages/nfe_cte_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## � Diferenciais

- **Paridade SEFAZ**: Layouts que são cópias idênticas dos documentos oficiais.
- **Inteligência de Parsing**: O `FiscalParser` detecta e processa NF-e, CT-e e NFC-e automaticamente.
- **Performance Nativa**: 100% Dart, otimizado para lidar com centenas de itens sem travar a UI.
- **Multi-Plataforma**: Android, iOS, Web, Windows e macOS.
- **Suporte a NFC-e**: Geração de cupons fiscais com suporte a QR Code.

---

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  nfe_cte_viewer: ^0.1.0
  printing: ^5.11.0 # Altamente recomendado para visualização e impressão
```

---

## 🛠 Guia de Uso Completo

### 1. Processamento Automático via XML (O mais comum)

Este exemplo demonstra como ler um XML, identificar o tipo de documento e gerar o PDF pronto para exibição ou impressão.

```dart
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';
import 'dart:io';

Future<void> handleFiscalDocument(String xmlPath) async {
  // 1. Carrega o conteúdo do XML
  final xmlContent = await File(xmlPath).readAsString();

  // 2. Faz o parsing automático (identifica se é NF-e, CT-e ou NFC-e)
  final doc = FiscalParser.parse(xmlContent);

  // 3. Processa e gera o PDF baseado no tipo detectado
  late final Uint8List pdfBytes;

  if (doc.isCte) {
    // Caso seja CT-e (Dacte)
    final data = DacteMapper.fromDomain(doc);
    pdfBytes = await DacteSefazPrinter(data).generate();
  } else if (doc.isNfce) {
    // Caso seja NFC-e (Cupom)
    final data = NfceMapper.fromDomain(doc);
    pdfBytes = await NfceSefazPrinter(data).generate();
  } else {
    // Caso seja NF-e (Danfe)
    final data = DanfeMapper.fromDomain(doc);
    pdfBytes = await DanfeSefazPrinter(data).generate();
  }

  // Agora você pode usar os pdfBytes para salvar ou exibir com o pacote 'printing'
}
```

### 2. Criação Manual (Sem XML)

Se você tem os dados em objetos e quer gerar o documento diretamente:

```dart
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';

Future<Uint8List> generateManualDanfe() async {
  final doc = DocumentoFiscal(
    chaveAcesso: '35231012345678000199550010000001231000001234',
    numero: '123',
    serie: '1',
    naturezaOperacao: 'VENDA DE MERCADORIA',
    dataEmissao: DateTime.now(),
    emitente: const Participante(
      nome: 'SUA EMPRESA LTDA',
      cnpj: '12.345.678/0001-99',
      ie: '123456789',
      enderecoLogradouro: 'RUA PRINCIPAL',
      enderecoNumero: '100',
      enderecoBairro: 'CENTRO',
      enderecoMunicipio: 'SAO PAULO',
      enderecoUf: 'SP',
    ),
    destinatario: const Participante(
      nome: 'CLIENTE EXEMPLO',
      cnpj: '98.765.432/0001-00',
      enderecoLogradouro: 'AVENIDA SECUNDARIA',
      enderecoMunicipio: 'CURITIBA',
      enderecoUf: 'PR',
    ),
    itens: [
      const ItemDocumentoFiscal(
        codigo: '001',
        descricao: 'PRODUTO DE TESTE',
        quantidade: 1.0,
        valorUnitario: 100.0,
        valorTotal: 100.0,
      ),
    ],
    valorTotalProdutos: 100.0,
    valorTotalNota: 100.0,
  );

  final mapperData = DanfeMapper.fromDomain(doc);
  return await DanfeSefazPrinter(mapperData).generate();
}
```

---

## 🧩 Componentes do Sistema

| Componente | Responsabilidade |
| :--- | :--- |
| **`FiscalParser`** | Analisa o XML bruto e converte em um `DocumentoFiscal` agnóstico. |
| **`Mappers`** | Transformam o `DocumentoFiscal` em dados específicos de cada layout (`DanfeData`, `DacteData`, `NfceData`). |
| **`Printers`** | Motores de renderização em PDF. |

---

## 💻 Configuração para macOS

Se a sua aplicação falhar ao abrir arquivos XML no macOS, certifique-se de adicionar as permissões de Sandbox em `DebugProfile.entitlements` e `Release.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-only</key>
<true/>
```

---

## 🌍 Exemplos Reais

O diretório `example/` contém uma aplicação Flutter completa demonstrando:
1. Dashboard de gerenciamento fiscal.
2. Carregamento de arquivos XML via File Picker.
3. Preview interativo de documentos.
4. Geração de PDF em tempo real.

---

## 🤝 Contribuição e Suporte

Tem uma ideia ou encontrou um bug? 
- Abra uma **Issue** explicando o caso.
- Envie um **Pull Request** para melhorias.

Próximos passos do Roadmap:
- [ ] Eventos (Cancelamento, Carta de Correção).
- [ ] MDFe (Manifesto).
- [ ] Impressão Térmica Direta (ESC/POS).

---

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais informações.

Desenvolvido com ❤️ por [Domani Sistemas](https://github.com/domani-sistemas).