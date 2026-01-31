//lib/src/models/fiscal/documento_fiscal.dart
import 'participante.dart';
import 'item_documento.dart';
import 'transporte.dart';
import 'impostos.dart';

/// Representa o documento fiscal completo (NF-e ou CT-e)
class DocumentoFiscal {
  final String? chaveAcesso;
  final String? modelo;
  final String? serie;
  final String? numero;
  final DateTime? dataEmissao;
  final String? naturezaOperacao;
  final String? protocoloAutorizacao;
  final bool saida;

  // Participantes Gerais
  final Participante? emitente;
  final Participante? destinatario;

  // Participantes específicos do CT-e
  final bool isCte;
  final Participante? remetente;
  final Participante? expedidor;
  final Participante? recebedor;
  final Participante? tomador;

  // Localização do Serviço (CT-e)
  final String? municipioInicio;
  final String? ufInicio;
  final String? municipioFim;
  final String? ufFim;
  final String? modal;

  // Itens (NF-e)
  final List<ItemDocumentoFiscal> itens;

  // Valores (Geral/CT-e)
  final Transporte? transporte;
  final Impostos? totaisImpostos;
  final double? valorTotalProdutos;
  final double? valorTotalNota;

  // Valores específicos CT-e
  final double? valorTotalServico;
  final double? valorReceber;
  final List<ComponenteValorCte> componentesValor;

  // Carga (CT-e)
  final String? produtoPredominante;
  final double? valorTotalCarga;
  final String? outrasCaracteristicasCarga;
  final List<MedidaCargaCte> medidasCarga;

  // Dados do Veículo/Modal (CT-e)
  final String? rntrc;
  final String? ciot;
  final DateTime? dataPrevistaEntrega;

  // Documentos (NF-e Relacionadas, etc)
  final List<DocumentoOriginarioCte> documentosOriginarios;

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
    this.isCte = false,
    this.emitente,
    this.destinatario,
    this.remetente,
    this.expedidor,
    this.recebedor,
    this.tomador,
    String? municipioInicio,
    String? ufInicio,
    String? municipioFim,
    String? ufFim,
    this.modal,
    this.itens = const [],
    this.transporte,
    this.totaisImpostos,
    this.valorTotalProdutos,
    this.valorTotalNota,
    double? valorTotalServico,
    this.valorReceber,
    this.componentesValor = const [],
    this.produtoPredominante,
    this.valorTotalCarga,
    this.outrasCaracteristicasCarga,
    this.medidasCarga = const [],
    this.rntrc,
    this.ciot,
    this.dataPrevistaEntrega,
    this.documentosOriginarios = const [],
    this.informacoesFisco,
    this.informacoesComplementares,
    String? tipoCte, // Para compatibilidade
    String? tipoServico, // Para compatibilidade
    String? municipioOrigem, // Alias para municipioInicio
    String? ufOrigem, // Alias para ufInicio
    String? municipioDestino, // Alias para municipioFim
    String? ufDestino, // Alias para ufFim
    double? valorPrestacao, // Alias para valorTotalServico
  })  : municipioInicio = municipioInicio ?? municipioOrigem,
        ufInicio = ufInicio ?? ufOrigem,
        municipioFim = municipioFim ?? municipioDestino,
        ufFim = ufFim ?? ufDestino,
        valorTotalServico = valorTotalServico ?? valorPrestacao;
}

class ComponenteValorCte {
  final String nome;
  final double valor;

  const ComponenteValorCte({required this.nome, required this.valor});
}

class MedidaCargaCte {
  final String tipoMedida;
  final double quantidade;
  final String unidade;

  const MedidaCargaCte({
    required this.tipoMedida,
    required this.quantidade,
    required this.unidade,
  });
}

class DocumentoOriginarioCte {
  final String tipo;
  final String? chave;
  final String? serieNro;
  final String? descricao;
  final String? numero;

  const DocumentoOriginarioCte({
    required this.tipo,
    this.chave,
    this.serieNro,
    this.descricao,
    this.numero,
  });
}
