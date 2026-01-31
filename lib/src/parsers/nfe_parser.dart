//lib/src/parsers/nfe_parser.dart
import 'package:xml/xml.dart';
import '../models/fiscal/documento_fiscal.dart';
import '../models/fiscal/participante.dart';
import '../models/fiscal/transporte.dart';
import '../models/fiscal/impostos.dart';
import '../models/fiscal/item_documento.dart';

class NfeParser {
  static DocumentoFiscal parse(String xmlContent) {
    final document = XmlDocument.parse(xmlContent);
    final nfe = document.findAllElements('infNFe').firstOrNull;

    if (nfe == null) {
      throw Exception('Elemento <infNFe> não encontrado no XML.');
    }

    final ide = nfe.findElements('ide').firstOrNull;
    final emit = nfe.findElements('emit').firstOrNull;
    final dest = nfe.findElements('dest').firstOrNull;
    final total = nfe
        .findElements('total')
        .firstOrNull
        ?.findElements('ICMSTot')
        .firstOrNull;

    return DocumentoFiscal(
      chaveAcesso: _parseChave(nfe),
      modelo: _parseVal(ide, 'mod'),
      serie: _parseVal(ide, 'serie'),
      numero: _parseVal(ide, 'nNF'),
      dataEmissao: DateTime.tryParse(_parseVal(ide, 'dhEmi') ?? ''),
      naturezaOperacao: _parseVal(ide, 'natOp'),
      protocoloAutorizacao: _parseProtocolo(document),
      emitente: _parseParticipante(emit, 'enderEmit'),
      destinatario: _parseParticipante(dest, 'enderDest'),
      itens: _parseItens(nfe),
      transporte: _parseTransporte(nfe.findElements('transp').firstOrNull),
      totaisImpostos: Impostos(
        vbc: _doubleText(total, 'vBC'),
        vicms: _doubleText(total, 'vICMS'),
        vbcst: _doubleText(total, 'vBCST'),
        vicmsst: _doubleText(total, 'vST'),
        vipi: _doubleText(total, 'vIPI'),
      ),
      valorTotalProdutos: _doubleText(total, 'vProd'),
      valorTotalNota: _doubleText(total, 'vNF'),
      informacoesComplementares:
          _parseVal(nfe.findElements('infAdic').firstOrNull, 'infCpl'),
    );
  }

  static String _parseChave(XmlElement nfe) {
    final id = nfe.getAttribute('Id') ?? '';
    return id.replaceAll('NFe', '').replaceAll('CTe', '');
  }

  static String _parseProtocolo(XmlDocument doc) {
    final prot = doc.findAllElements('infProt').firstOrNull;
    if (prot == null) return '';
    return '${_parseVal(prot, 'nProt') ?? ''} - ${_parseVal(prot, 'dhRecbto') ?? ''}';
  }

  static Participante _parseParticipante(XmlElement? el, String enderTag) {
    if (el == null) return const Participante();
    final ender = el.findElements(enderTag).firstOrNull;
    return Participante(
      nome: _parseVal(el, 'xNome'),
      cnpj: _parseVal(el, 'CNPJ'),
      cpf: _parseVal(el, 'CPF'),
      ie: _parseVal(el, 'IE'),
      enderecoLogradouro: _parseVal(ender, 'xLgr'),
      enderecoNumero: _parseVal(ender, 'nro'),
      enderecoBairro: _parseVal(ender, 'xBairro'),
      enderecoMunicipio: _parseVal(ender, 'xMun'),
      enderecoUf: _parseVal(ender, 'UF'),
      enderecoCep: _parseVal(ender, 'CEP'),
      enderecoTelefone: _parseVal(ender, 'fone'),
    );
  }

  static List<ItemDocumentoFiscal> _parseItens(XmlElement nfe) {
    return nfe.findElements('det').map((det) {
      final prod = det.findElements('prod').firstOrNull;
      final imp = det
          .findElements('imposto')
          .firstOrNull
          ?.findElements('ICMS')
          .firstOrNull
          ?.descendants
          .whereType<XmlElement>()
          .firstOrNull;

      return ItemDocumentoFiscal(
        codigo: _parseVal(prod, 'cProd'),
        descricao: _parseVal(prod, 'xProd'),
        ncm: _parseVal(prod, 'NCM'),
        cfop: _parseVal(prod, 'CFOP'),
        unidade: _parseVal(prod, 'uCom'),
        quantidade: _doubleText(prod, 'qCom'),
        valorUnitario: _doubleText(prod, 'vUnCom'),
        valorTotal: _doubleText(prod, 'vProd'),
        impostos: Impostos(
          vbc: _doubleText(imp, 'vBC'),
          vicms: _doubleText(imp, 'vICMS'),
        ),
      );
    }).toList();
  }

  static Transporte? _parseTransporte(XmlElement? transp) {
    if (transp == null) return null;
    final transporta = transp.findElements('transporta').firstOrNull;
    final veic = transp.findElements('veicTransp').firstOrNull;
    final vol = transp.findElements('vol').firstOrNull;

    return Transporte(
      modFrete: _parseVal(transp, 'modFrete'),
      transportadoraNome: _parseVal(transporta, 'xNome'),
      transportadoraCnpj:
          _parseVal(transporta, 'CNPJ') ?? _parseVal(transporta, 'CPF'),
      veiculoPlaca: _parseVal(veic, 'placa'),
      veiculoUf: _parseVal(veic, 'UF'),
      veiculoRntrc: _parseVal(veic, 'RNTRC'),
      volQuantidade: _parseVal(vol, 'qVol'),
      volEspecie: _parseVal(vol, 'esp'),
      volMarca: _parseVal(vol, 'marca'),
      pesoBruto: _doubleText(vol, 'pesoB'),
      pesoLiquido: _doubleText(vol, 'pesoL'),
    );
  }

  static String? _parseVal(XmlElement? el, String tag) {
    if (el == null) return null;
    final val = el.findElements(tag).firstOrNull?.innerText;
    return (val == null || val.isEmpty) ? null : val;
  }

  static double _doubleText(XmlElement? el, String tag) {
    final text = _parseVal(el, tag);
    return double.tryParse(text ?? '') ?? 0.0;
  }
}
