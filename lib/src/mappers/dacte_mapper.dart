//lib/src/mappers/dacte_mapper.dart
import 'package:intl/intl.dart';
import '../models/fiscal/documento_fiscal.dart';
import '../models/fiscal/participante.dart';
import '../models/dacte/dacte_data.dart';

class DacteMapper {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
  static final _dateOnlyFormat = DateFormat('dd/MM/yyyy');

  static String s(String? v) => v ?? '';
  static double d(double? v) => v ?? 0.0;
  static String f(double? v) => (v ?? 0.0).toStringAsFixed(2);

  static DacteData fromDomain(DocumentoFiscal doc) {
    return DacteData(
      chaveAcesso: s(doc.chaveAcesso),
      numero: s(doc.numero),
      serie: s(doc.serie),
      naturezaOperacao: s(doc.naturezaOperacao),
      protocoloAutorizacao: s(doc.protocoloAutorizacao),
      dataEmissao:
          doc.dataEmissao != null ? _dateFormat.format(doc.dataEmissao!) : '',
      modelo: s(doc.modelo),
      modalidadeFrete: 'Rodoviário',
      tipoCte: doc.isCte ? '0 - Normal' : '1 - Complementar', // Simple mapping
      tipoServico: '0 - Normal',
      tomadorServicoInfo: _mapTomadorInfo(doc),
      inicioPrestacao: s(doc.municipioInicio) + ' - ' + s(doc.ufInicio),
      fimPrestacao: s(doc.municipioFim) + ' - ' + s(doc.ufFim),
      emitente:
          _mapParticipante(doc.emitente) ?? const ParticipanteDacte(nome: ''),
      remetente: _mapParticipante(doc.remetente),
      destinatario: _mapParticipante(doc.destinatario),
      expedidor: _mapParticipante(doc.expedidor),
      recebedor: _mapParticipante(doc.recebedor),
      tomador: _mapParticipante(doc.tomador),
      produtoPredominante: s(doc.produtoPredominante),
      outrasCaracteristicas: s(doc.outrasCaracteristicasCarga),
      valorTotalCarga: d(doc.valorTotalCarga),
      pesoDeclarado: _extractMedida(doc, 'PESO'),
      volumes: _extractMedida(doc, 'VOLUME'),
      cubagem: _extractMedida(doc, 'CUBAGEM'),
      qtde: _extractMedida(doc, 'QTDE'),
      componentes: doc.componentesValor
          .map((c) => ComponenteValorDacte(
                nome: c.nome,
                valor: f(c.valor),
              ))
          .toList(),
      valorTotalServico: d(doc.valorTotalServico),
      valorReceber: d(doc.valorReceber),
      situacaoTributaria: '00',
      baseIcms: d(doc.totaisImpostos?.vbc),
      aliqIcms: d(doc.totaisImpostos?.pcms),
      valorIcms: d(doc.totaisImpostos?.vicms),
      redBcIcms: 0.0,
      icmsSt: d(doc.totaisImpostos?.vicmsst),
      documentosOriginarios: doc.documentosOriginarios
          .map((d) => DocumentoOriginarioDacte(
                tipo: d.tipo,
                cnpjChave: d.chave ?? d.numero ?? '',
                serieNro: d.serieNro ?? '',
              ))
          .toList(),
      observacoes: s(doc.informacoesComplementares),
      rntrc: s(doc.rntrc),
      ciot: s(doc.ciot),
      dataPrevistaEntrega: doc.dataPrevistaEntrega != null
          ? _dateOnlyFormat.format(doc.dataPrevistaEntrega!)
          : '',
    );
  }

  static String _extractMedida(DocumentoFiscal doc, String search) {
    try {
      final m = doc.medidasCarga.firstWhere(
        (m) => m.tipoMedida.toUpperCase().contains(search.toUpperCase()),
      );
      return m.quantidade.toString();
    } catch (_) {
      return '0';
    }
  }

  static String _mapTomadorInfo(DocumentoFiscal doc) {
    if (doc.tomador == null) return '';
    return s(doc.tomador!.nome);
  }

  static ParticipanteDacte? _mapParticipante(Participante? p) {
    if (p == null) return null;
    return ParticipanteDacte(
      nome: s(p.nome),
      logradouro: s(p.enderecoLogradouro),
      numero: s(p.enderecoNumero),
      bairro: s(p.enderecoBairro),
      municipio: s(p.enderecoMunicipio),
      uf: s(p.enderecoUf),
      cep: s(p.enderecoCep),
      cnpjCpf: s(p.cnpj ?? p.cpf),
      ie: s(p.ie),
      fone: s(p.enderecoTelefone),
      pais: s(p.enderecoPais ?? 'BRASIL'),
    );
  }
}
