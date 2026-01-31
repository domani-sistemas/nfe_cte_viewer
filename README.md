# nfe_cte_viewer

Um pacote Flutter poderoso para gerar PDFs de documentos fiscais brasileiros em conformidade com a SEFAZ. Focado em paridade visual 1:1 com os padrões oficiais e alta performance.

[![Pub Version](https://img.shields.io/pub/v/nfe_cte_viewer)](https://pub.dev/packages/nfe_cte_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🚀 Funcionalidades

- **NF-e (DANFE)**: Suporte completo para o Documento Auxiliar da Nota Fiscal Eletrônica.
- **CT-e (DACTE)**: Documento Auxiliar do Conhecimento de Transporte Eletrônico de alta fidelidade.
- **Pixel Perfect**: Paridade visual 1:1 com os padrões oficiais da SEFAZ.
- **Pure Dart/Flutter**: Construído sobre o pacote `pdf`, sem dependências nativas para a geração.
- **Integração Fácil**: Modelos de domínio e mappers desacoplados.

## 📦 Instalação

Adicione `nfe_cte_viewer` ao seu `pubspec.yaml`:

```yaml
dependencies:
  nfe_cte_viewer: ^0.1.0
```

## 🛠 Uso

### Gerando um DANFE (NF-e)

```dart
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';

// 1. Prepare seus dados de domínio
final doc = DocumentoFiscal(
  chaveAcesso: '...',
  // ... preencha com seus dados
);

// 2. Mapeie para os dados de renderização
final danfeData = DanfeMapper.fromDomain(doc);

// 3. Gere o PDF
final printer = DanfeSefazPrinter(danfeData);
final Uint8List pdfBytes = await printer.generate();
```

### Gerando um DACTE (CT-e)

```dart
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';

// 1. Prepare seus dados de domínio
final doc = DocumentoFiscal(
  chaveAcesso: '...',
  // ... preencha com seus dados específicos de CT-e
);

// 2. Mapeie para os dados de renderização
final dacteData = DacteMapper.fromDomain(doc);

// 3. Gere o PDF
final printer = DacteSefazPrinter(dacteData);
final Uint8List pdfBytes = await printer.generate();
```

## 📱 Aplicativo de Exemplo

O pacote inclui um aplicativo de exemplo completo na pasta `example`. Ele possui uma visualização em abas para ambos os tipos de documentos usando o pacote `printing`.

Para executá-lo:

```bash
cd example
flutter run
```

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para:
- Relatar bugs via issues.
- Propor novos recursos (o suporte a NFC-e está no roteiro!).
- Enviar pull requests.

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---
Desenvolvido com ❤️ por [Domani Sistemas](https://github.com/domani-sistemas).