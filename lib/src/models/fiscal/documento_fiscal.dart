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
  final Participante? remetente;
  final Participante? expedidor;
  final Participante? recebedor;
  final Participante? tomador;

  final String? municipioOrigem;
  final String? ufOrigem;
  final String? municipioDestino;
  final String? ufDestino;

  final List<ItemDocumentoFiscal> itens;

  final Transporte? transporte;
  final Impostos? totaisImpostos;
  final double? valorTotalProdutos;
  final double? valorTotalNota;
  final double? valorPrestacao;
  final double? valorReceber;

  final String? tipoCte;
  final String? tipoServico;
  final DateTime? dataPrevistaEntrega;
  final List<String>? documentosOriginarios;

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
    this.remetente,
    this.expedidor,
    this.recebedor,
    this.tomador,
    this.municipioOrigem,
    this.ufOrigem,
    this.municipioDestino,
    this.ufDestino,
    this.itens = const [],
    this.transporte,
    this.totaisImpostos,
    this.valorTotalProdutos,
    this.valorTotalNota,
    this.valorPrestacao,
    this.valorReceber,
    this.tipoCte,
    this.tipoServico,
    this.dataPrevistaEntrega,
    this.documentosOriginarios,
    this.informacoesFisco,
    this.informacoesComplementares,
  });
}
