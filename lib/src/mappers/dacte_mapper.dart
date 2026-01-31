//lib/src/mappers/dacte_mapper.dart
import 'package:intl/intl.dart';
import '../models/fiscal/documento_fiscal.dart';
import '../models/fiscal/participante.dart';
import '../models/dacte/dacte_data.dart';

class DacteMapper {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

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
      modalidadeFrete: s(doc.transporte?.modFrete),
      municipioOrigem: s(doc.municipioOrigem),
      ufOrigem: s(doc.ufOrigem),
      municipioDestino: s(doc.municipioDestino),
      ufDestino: s(doc.ufDestino),
      emitente: _mapParticipante(doc.emitente)!,
      remetente: _mapParticipante(doc.remetente),
      destinatario: _mapParticipante(doc.destinatario),
      expedidor: _mapParticipante(doc.expedidor),
      recebedor: _mapParticipante(doc.recebedor),
      tomador: _mapParticipante(doc.tomador),
      produtoPredominante: s(doc.transporte?.volEspecie), // Placeholder
      outrasCaracteristicas: s(doc.transporte?.volMarca), // Placeholder
      pesoBruto: d(doc.transporte?.pesoBruto),
      pesoLiquido: d(doc.transporte?.pesoLiquido),
      valorCarga: d(doc.valorTotalProdutos), // Geralmente o valor da mercadoria
      totais: TotaisDacte(
        valorTotalServico: d(doc.valorPrestacao),
        valorReceber: d(doc.valorReceber),
        baseIcms: d(doc.totaisImpostos?.vbc),
        aliqIcms: 0.0, // Regra de negócio
        valorIcms: d(doc.totaisImpostos?.vicms),
      ),
      informacoesComplementares: s(doc.informacoesComplementares),
    );
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
    );
  }
}
