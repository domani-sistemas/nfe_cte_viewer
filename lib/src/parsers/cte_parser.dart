//lib/src/parsers/cte_parser.dart
import 'package:xml/xml.dart';
import '../models/fiscal/documento_fiscal.dart';
import '../models/fiscal/participante.dart';
import '../models/fiscal/impostos.dart';

class CteParser {
  static DocumentoFiscal parse(String xmlContent) {
    final document = XmlDocument.parse(xmlContent);
    final cte = document.findAllElements('infCte').first;
    final ide = cte.findElements('ide').first;
    final emit = cte.findElements('emit').first;
    final vPrest = cte.findElements('vPrest').first;
    final imp = cte
        .findElements('imp')
        .first
        .findElements('ICMS')
        .first
        .descendants
        .whereType<XmlElement>()
        .firstOrNull;
    final infNorm = cte.findElements('infCTeNorm').firstOrNull;
    final infCarga = infNorm?.findElements('infCarga').firstOrNull;

    return DocumentoFiscal(
      isCte: true,
      chaveAcesso: _parseChave(cte),
      modelo: _parseVal(ide, 'mod'),
      serie: _parseVal(ide, 'serie'),
      numero: _parseVal(ide, 'nCT'),
      dataEmissao: DateTime.tryParse(_parseVal(ide, 'dhEmi') ?? ''),
      naturezaOperacao: _parseVal(ide, 'natOp'),
      protocoloAutorizacao: _parseProtocolo(document),
      modal: _parseVal(ide, 'modal'),
      municipioInicio: _parseVal(ide, 'xMunIni'),
      ufInicio: _parseVal(ide, 'UFIni'),
      municipioFim: _parseVal(ide, 'xMunFim'),
      ufFim: _parseVal(ide, 'UFFim'),
      emitente: _parseParticipante(emit, 'enderEmit'),
      remetente:
          _parseParticipante(cte.findElements('rem').firstOrNull, 'enderReme'),
      destinatario:
          _parseParticipante(cte.findElements('dest').firstOrNull, 'enderDest'),
      expedidor: _parseParticipante(
          cte.findElements('exped').firstOrNull, 'enderExped'),
      recebedor: _parseParticipante(
          cte.findElements('receb').firstOrNull, 'enderReceb'),
      tomador: _parseTomador(cte, ide),
      valorTotalServico: _doubleText(vPrest, 'vTPrest'),
      valorReceber: _doubleText(vPrest, 'vRec'),
      componentesValor: _parseComponentes(vPrest),
      produtoPredominante: _parseVal(infCarga, 'proPred'),
      valorTotalCarga: _doubleText(infCarga, 'vCarga'),
      outrasCaracteristicasCarga: _parseVal(infCarga, 'xOutCat'),
      medidasCarga: _parseMedidas(infCarga),
      documentosOriginarios: _parseDocumentosOriginarios(infNorm),
      rntrc: _parseVal(
          infNorm
              ?.findElements('infModal')
              .firstOrNull
              ?.descendants
              .whereType<XmlElement>()
              .firstOrNull,
          'RNTRC'),
      ciot: _parseVal(
          infNorm
              ?.findElements('infModal')
              .firstOrNull
              ?.descendants
              .whereType<XmlElement>()
              .firstOrNull,
          'CIOT'),
      dataPrevistaEntrega: _parseDataPrevista(cte),
      totaisImpostos: Impostos(
        vbc: _doubleText(imp, 'vBC'),
        vicms: _doubleText(imp, 'vICMS'),
        pcms: _doubleText(imp, 'pICMS'),
      ),
      informacoesComplementares:
          _parseVal(cte.findElements('compl').firstOrNull, 'xObs'),
    );
  }

  static String _parseChave(XmlElement cte) {
    final id = cte.getAttribute('Id') ?? '';
    return id.replaceAll('CTe', '').replaceAll('NFe', '');
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
      enderecoPais: _parseVal(ender, 'xPais'),
    );
  }

  static Participante? _parseTomador(XmlElement cte, XmlElement ide) {
    final toma3 = ide.findElements('toma3').firstOrNull;
    if (toma3 != null) {
      final tomaCode = _parseVal(toma3, 'toma');
      switch (tomaCode) {
        case '0':
          return _parseParticipante(
              cte.findElements('rem').firstOrNull, 'enderReme');
        case '1':
          return _parseParticipante(
              cte.findElements('exped').firstOrNull, 'enderExped');
        case '2':
          return _parseParticipante(
              cte.findElements('receb').firstOrNull, 'enderReceb');
        case '3':
          return _parseParticipante(
              cte.findElements('dest').firstOrNull, 'enderDest');
      }
    }
    final toma4 = ide.findElements('toma4').firstOrNull;
    if (toma4 != null) {
      return _parseParticipante(toma4, 'enderToma');
    }
    return null;
  }

  static List<ComponenteValorCte> _parseComponentes(XmlElement vPrest) {
    return vPrest
        .findElements('Comp')
        .map((c) => ComponenteValorCte(
              nome: _parseVal(c, 'xNome') ?? '',
              valor: _doubleText(c, 'vComp'),
            ))
        .toList();
  }

  static List<MedidaCargaCte> _parseMedidas(XmlElement? infCarga) {
    if (infCarga == null) return [];
    return infCarga
        .findElements('infQ')
        .map((q) => MedidaCargaCte(
              tipoMedida: _parseVal(q, 'tpMed') ?? '',
              quantidade: _doubleText(q, 'qCarga'),
              unidade: _parseVal(q, 'cUnid') ?? '',
            ))
        .toList();
  }

  static List<DocumentoOriginarioCte> _parseDocumentosOriginarios(
      XmlElement? infNorm) {
    if (infNorm == null) return [];
    final infDoc = infNorm.findElements('infDoc').firstOrNull;
    if (infDoc == null) return [];

    final docs = <DocumentoOriginarioCte>[];
    for (var nfe in infDoc.findElements('infNFe')) {
      docs.add(
          DocumentoOriginarioCte(tipo: 'NF-e', chave: _parseVal(nfe, 'chave')));
    }
    for (var infOutros in infDoc.findElements('infOutros')) {
      docs.add(DocumentoOriginarioCte(
        tipo: _parseVal(infOutros, 'tpDoc') ?? 'Outros',
        descricao: _parseVal(infOutros, 'descOutros'),
        numero: _parseVal(infOutros, 'nDoc'),
      ));
    }
    return docs;
  }

  static DateTime? _parseDataPrevista(XmlElement cte) {
    final compl = cte.findElements('compl').firstOrNull;
    final entrega = compl?.findElements('Entrega').firstOrNull;
    final comData = entrega?.findElements('comData').firstOrNull;
    if (comData != null) {
      return DateTime.tryParse(_parseVal(comData, 'dProg') ?? '');
    }
    return null;
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
