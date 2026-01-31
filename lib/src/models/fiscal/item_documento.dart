import 'impostos.dart';

/// Representa um item da nota fiscal
class ItemDocumentoFiscal {
  final String? codigo;
  final String? descricao;
  final String? ncm;
  final String? cfop;
  final String? unidade;
  final double? quantidade;
  final double? valorUnitario;
  final double? valorTotal;
  final String? cst;
  final Impostos? impostos;

  const ItemDocumentoFiscal({
    this.codigo,
    this.descricao,
    this.ncm,
    this.cfop,
    this.unidade,
    this.quantidade,
    this.valorUnitario,
    this.valorTotal,
    this.cst,
    this.impostos,
  });
}
