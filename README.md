# nfe_cte_viewer

Um pacote Flutter poderoso e robusto para gerar PDFs de documentos fiscais brasileiros (NF-e e CT-e) em conformidade rigorosa com a SEFAZ. Focado em **paridade visual 1:1**, alta performance e facilidade de integração via XML ou modelos de dados.

[![Pub Version](https://img.shields.io/pub/v/nfe_cte_viewer)](https://pub.dev/packages/nfe_cte_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🚀 Funcionalidades Principais

- **NF-e (DANFE)**: Representação fiel do Documento Auxiliar da Nota Fiscal Eletrônica.
- **CT-e (DACTE)**: Representação fiel do Documento Auxiliar do Conhecimento de Transporte Eletrônico.
- **Parsing de XML**: Processamento automático de arquivos `.xml` da SEFAZ com detecção inteligente de tipo.
- **Pixel Perfect**: Layouts desenhados milimetricamente para coincidir com os padrões oficiais.
- **Dual-Mode**: Gere PDFs a partir de arquivos XML ou diretamente de modelos de dados em memória.
- **Multi-Página**: Suporte inteligente a quebra de página para tabelas longas de produtos.
- **Pure Dart/Flutter**: Sem dependências nativas pesadas, rodando em Android, iOS, Web, Windows e macOS.

---

## 📦 Instalação

Adicione `nfe_cte_viewer` ao seu `pubspec.yaml`:

```yaml
dependencies:
  nfe_cte_viewer: ^0.1.0
  printing: ^5.11.0 # Recomendado para visualização/impressão
```

### Configuração macOS (File Picker)
Se estiver usando o seletor de arquivos no macOS, adicione as seguintes permissões ao seu `DebugProfile.entitlements` e `Release.entitlements`:

```xml
<key>com.apple.security.files.user-selected.read-only</key>
<true/>
```

---

## 🛠 Como Usar

### 1. Via Arquivo XML (Recomendado)

O pacote facilita a vida ao detectar automaticamente se o XML é uma NF-e ou um CT-e.

```dart
import 'package:nfe_cte_viewer/nfe_cte_viewer.dart';

// Carregue a String do seu XML
String xmlContent = await File('caminho_do_seu_xml.xml').readAsString();

// O FiscalParser identifica e processa automaticamente
final doc = FiscalParser.parse(xmlContent);

// Gere o PDF adequado
if (doc.isCte) {
  final dacteData = DacteMapper.fromDomain(doc);
  final printer = DacteSefazPrinter(dacteData);
  final pdfBytes = await printer.generate();
} else {
  final danfeData = DanfeMapper.fromDomain(doc);
  final printer = DanfeSefazPrinter(danfeData);
  final pdfBytes = await printer.generate();
}
```

### 2. Via Modelos de Dados (Manual)

Útil quando você já possui os dados em objetos e não quer lidar com XML.

```dart
final doc = DocumentoFiscal(
  chaveAcesso: '29251126935422000142550020001850531131148660',
  numero: '185053',
  serie: '2',
  naturezaOperacao: 'VENDA DE MERCADORIA',
  // ... outros campos
);

// Siga o fluxo de Printer como no exemplo acima
```

---

## 📱 Exemplo Premium

O pacote conta com um aplicativo de exemplo (`example/`) que demonstra:
- **Dashboard Moderno**: Interface refinada com tema escuro e ícones intuitivos.
- **File Picker**: Carregue seus próprios XMLs e veja o resultado instantaneamente.
- **Preview Interativo**: Visualização em tempo real do PDF com zoom e scroll.
- **Modo Offline**: Teste com amostras embutidas sem precisar de arquivos externos.

Para rodar:
```bash
cd example
flutter run
```

---

## 🏗 Arquitetura

O pacote é dividido em camadas claras:
- **Models**: Estruturas de dados universais para NF-e/CT-e.
- **Parsers**: Lógica robusta com tratamento defensivo para XMLs reais (tags ausentes ou opcionais).
- **Mappers**: Conversores de domínios fiscais para estruturas de renderização.
- **Printers**: Motores de geração de PDF baseados no oficial `pdf/widgets`.

---

## 🤝 Contribuição

Sinta-se à vontade para abrir Issues ou Pull Requests. Estamos focados em:
1. Adicionar suporte a **NFC-e**.
2. Suporte a **Eventos da Nota** (Cancelamento, Carta de Correção).
3. Melhores validações de esquemas XML.

---

## 📄 Licença

Este projeto está licenciado sob a Licença MIT.

Desenvolvido por [Domani Sistemas](https://github.com/domani-sistemas).