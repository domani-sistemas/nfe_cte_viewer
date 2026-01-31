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
      modalidadeFrete: 'Rodoviário', // Fixo para este modal
      tipoCte: s(doc.tipoCte),
      tipoServico: s(doc.tipoServico),
      tomadorServicoInfo: _mapTomadorInfo(doc),
      inicioPrestacao: s(doc.municipioOrigem) + ' - ' + s(doc.ufOrigem),
      fimPrestacao: s(doc.municipioDestino) + ' - ' + s(doc.ufDestino),
      emitente: _mapParticipante(doc.emitente)!,
      remetente: _mapParticipante(doc.remetente),
      destinatario: _mapParticipante(doc.destinatario),
      expedidor: _mapParticipante(doc.expedidor),
      recebedor: _mapParticipante(doc.recebedor),
      tomador: _mapParticipante(doc.tomador),
      produtoPredominante: s(doc.transporte?.volEspecie),
      outrasCaracteristicas: s(doc.transporte?.volMarca),
      valorTotalCarga: d(doc.valorTotalProdutos),
      pesoDeclarado: '${d(doc.transporte?.pesoBruto)} KG',
      volumes: s(doc.transporte?.volQuantidade),
      cubagem: '0.000',
      qtde: '0',
      componentes: [
        ComponenteValorDacte(
            nome: 'FRETE PESO',
            valor: d(doc.transporte?.valorFrete).toStringAsFixed(2)),
        // Pode adicionar mais se o modelo fiscal suportar
      ],
      valorTotalServico: d(doc.valorPrestacao),
      valorReceber: d(doc.valorReceber),
      situacaoTributaria: '00 - ICMS normal', // Placeholder
      baseIcms: d(doc.totaisImpostos?.vbc),
      aliqIcms: 0.0,
      valorIcms: d(doc.totaisImpostos?.vicms),
      redBcIcms: 0.0,
      icmsSt: d(doc.totaisImpostos?.vicmsst),
      documentosOriginarios: (doc.documentosOriginarios ?? [])
          .map((key) => DocumentoOriginarioDacte(
                tipo: 'NFE',
                cnpjChave: key,
                serieNro: '',
              ))
          .toList(),
      observacoes: s(doc.informacoesComplementares),
      rntrc: s(doc.transporte?.veiculoRntrc),
      ciot: s(doc.transporte?.ciot),
      dataPrevistaEntrega: doc.dataPrevistaEntrega != null
          ? _dateOnlyFormat.format(doc.dataPrevistaEntrega!)
          : '',
    );
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
      pais: 'BRASIL',
    );
  }
}
