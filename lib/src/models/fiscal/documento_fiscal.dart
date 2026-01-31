//lib/src/models/fiscal/documento_fiscal.dart
import 'participante.dart';
import 'item_documento.dart';
import 'transporte.dart';
import 'impostos.dart';

/// Representa o documento fiscal completo (NF-e)
class DocumentoFiscal {
  final String? chaveAcesso;
  final String? modelo;
  final String? serie;
  final String? numero;
  final DateTime? dataEmissao;
  final String? naturezaOperacao;
  final String? protocoloAutorizacao;
  final bool saida;

  final Participante? emitente;
  final Participante? destinatario;
  final List<ItemDocumentoFiscal> itens;

  final Transporte? transporte;
  final Impostos? totaisImpostos;
  final double? valorTotalProdutos;
  final double? valorTotalNota;

  final String? informacoesFisco;
  final String? informacoesComplementares;

  const DocumentoFiscal({
    this.chaveAcesso,
    this.modelo,
    this.serie,
    this.numero,
    this.dataEmissao,
    this.naturezaOperacao,
    this.protocoloAutorizacao,
    this.saida = true,
    this.emitente,
    this.destinatario,
    this.itens = const [],
    this.transporte,
    this.totaisImpostos,
    this.valorTotalProdutos,
    this.valorTotalNota,
    this.informacoesFisco,
    this.informacoesComplementares,
  });
}
