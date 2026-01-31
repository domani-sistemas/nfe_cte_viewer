//lib/src/mappers/danfe_mapper.dart
import 'package:intl/intl.dart';
import '../models/fiscal/documento_fiscal.dart';
import '../models/danfe/danfe_data.dart';

/// Mapper responsável por converter o domínio fiscal para o modelo de renderização DANFE.
class DanfeMapper {
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  /// Helper para garantir String não nula
  static String s(String? v) => v ?? '';

  /// Helper para garantir double não nulo
  static double d(double? v) => v ?? 0.0;

  static DanfeData fromDomain(DocumentoFiscal doc) {
    return DanfeData(
      chaveAcesso: s(doc.chaveAcesso),
      numero: s(doc.numero),
      serie: s(doc.serie),
      naturezaOperacao: s(doc.naturezaOperacao),
      protocoloAutorizacao: s(doc.protocoloAutorizacao),
      dataEmissao:
          doc.dataEmissao != null ? _dateFormat.format(doc.dataEmissao!) : '',
      isSaida: doc.saida,
      emitente: _mapEmitente(doc),
      destinatario: _mapDestinatario(doc),
      itens: doc.itens.map((i) => _mapItem(i)).toList(),
      totais: _mapTotais(doc),
      transporte: _mapTransporte(doc),
      dadosAdicionais: _mapDadosAdicionais(doc),
    );
  }

  static EmitenteDanfe _mapEmitente(DocumentoFiscal doc) {
    final e = doc.emitente;
    return EmitenteDanfe(
      nome: s(e?.nome),
      logradouro: s(e?.enderecoLogradouro),
      numero: s(e?.enderecoNumero),
      bairro: s(e?.enderecoBairro),
      municipio: s(e?.enderecoMunicipio),
      uf: s(e?.enderecoUf),
      cep: s(e?.enderecoCep),
      cnpj: s(e?.cnpj),
      ie: s(e?.ie),
      fone: s(e?.enderecoTelefone),
    );
  }

  static DestinatarioDanfe _mapDestinatario(DocumentoFiscal doc) {
    final d = doc.destinatario;
    return DestinatarioDanfe(
      nome: s(d?.nome),
      logradouro: s(d?.enderecoLogradouro),
      numero: s(d?.enderecoNumero),
      bairro: s(d?.enderecoBairro),
      municipio: s(d?.enderecoMunicipio),
      uf: s(d?.enderecoUf),
      cep: s(d?.enderecoCep),
      cnpjCpf: s(d?.cnpj ?? d?.cpf),
      ie: s(d?.ie),
      fone: s(d?.enderecoTelefone),
      dataEmissao:
          doc.dataEmissao != null ? _dateFormat.format(doc.dataEmissao!) : '',
    );
  }

  static ItemDanfe _mapItem(dynamic item) {
    return ItemDanfe(
      codigo: s(item.codigo),
      descricao: s(item.descricao),
      ncm: s(item.ncm),
      cfop: s(item.cfop),
      cst: s(item.cst),
      unidade: s(item.unidade),
      quantidade: d(item.quantidade),
      valorUnitario: d(item.valorUnitario),
      valorTotal: d(item.valorTotal),
      baseIcms: d(item.impostos?.vbc),
      valorIcms: d(item.impostos?.vicms),
      valorIpi: d(item.impostos?.vipi),
      aliqIcms: 0.0, // Regra de cálculo ou do XML
      aliqIpi: 0.0, // Regra de cálculo ou do XML
    );
  }

  static TotaisDanfe _mapTotais(DocumentoFiscal doc) {
    final t = doc.totaisImpostos;
    return TotaisDanfe(
      baseIcms: d(t?.vbc),
      valorIcms: d(t?.vicms),
      baseIcmsSt: d(t?.vbcst),
      valorIcmsSt: d(t?.vicmsst),
      valorProdutos: d(doc.valorTotalProdutos),
      valorFrete: d(doc.transporte?.valorFrete),
      valorSeguro: d(doc.transporte?.valorSeguro),
      valorDesconto: 0.0,
      outrasDespesas: 0.0,
      valorIpi: d(t?.vipi),
      valorTotalNota: d(doc.valorTotalNota),
    );
  }

  static TransporteDanfe _mapTransporte(DocumentoFiscal doc) {
    final t = doc.transporte;
    return TransporteDanfe(
      modalidadeFrete: s(t?.modFrete),
      transportadorNome: s(t?.transportadoraNome),
      transportadorCnpjCpf: s(t?.transportadoraCnpj),
      transportadoraIe: s(
        t?.veiculoRntrc,
      ), // Apenas placeholder se não tiver campo específico
      transportadoraEndereco: s(t?.transportadoraEndereco),
      transportadoraMunicipio: s(t?.transportadoraMunicipio),
      transportadoraUf: s(t?.transportadoraUf),
      placaVeiculo: s(t?.veiculoPlaca),
      ufVeiculo: s(t?.veiculoUf),
      rntrc: s(t?.veiculoRntrc),
      quantidade: s(t?.volQuantidade),
      especie: s(t?.volEspecie),
      marca: s(t?.volMarca),
      numeracao: s(t?.volNumeracao),
      pesoBruto: d(t?.pesoBruto),
      pesoLiquido: d(t?.pesoLiquido),
    );
  }

  static DadosAdicionaisDanfe _mapDadosAdicionais(DocumentoFiscal doc) {
    return DadosAdicionaisDanfe(
      informacoesFisco: s(doc.informacoesFisco),
      informacoesComplementares: s(doc.informacoesComplementares),
    );
  }
}
