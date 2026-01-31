//lib/src/parsers/fiscal_parser.dart
import 'package:xml/xml.dart';
import '../models/fiscal/documento_fiscal.dart';
import 'nfe_parser.dart';
import 'cte_parser.dart';

class FiscalParser {
  /// Parses a SEFAZ XML (NF-e or CT-e) and returns a [DocumentoFiscal].
  static DocumentoFiscal parse(String xmlContent) {
    final document = XmlDocument.parse(xmlContent);

    final isNfe = document.findAllElements('infNFe').isNotEmpty;
    final isCte = document.findAllElements('infCte').isNotEmpty;

    if (isNfe) {
      return NfeParser.parse(xmlContent);
    } else if (isCte) {
      return CteParser.parse(xmlContent);
    } else {
      throw Exception(
          'Formato de XML não suportado ou inválido (não é NF-e nem CT-e).');
    }
  }
}
