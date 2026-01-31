//lib/src/models/dacte/dacte_data.dart

class ParticipanteDacte {
  final String nome;
  final String logradouro;
  final String numero;
  final String bairro;
  final String municipio;
  final String uf;
  final String cep;
  final String cnpjCpf;
  final String ie;
  final String fone;
  final String pais;

  const ParticipanteDacte({
    required this.nome,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.municipio,
    required this.uf,
    required this.cep,
    required this.cnpjCpf,
    required this.ie,
    required this.fone,
    required this.pais,
  });

  String get enderecoCompleto => '$logradouro, $numero - $bairro';
}

class ComponenteValorDacte {
  final String nome;
  final String valor;

  const ComponenteValorDacte({required this.nome, required this.valor});
}

class DocumentoOriginarioDacte {
  final String tipo;
  final String cnpjChave;
  final String serieNro;

  const DocumentoOriginarioDacte({
    required this.tipo,
    required this.cnpjChave,
    required this.serieNro,
  });
}

class DacteData {
  final String chaveAcesso;
  final String numero;
  final String serie;
  final String naturezaOperacao;
  final String protocoloAutorizacao;
  final String dataEmissao;
  final String modelo;
  final String modalidadeFrete;
  final String tipoCte;
  final String tipoServico;
  final String tomadorServicoInfo;

  final String inicioPrestacao;
  final String fimPrestacao;

  final ParticipanteDacte emitente;
  final ParticipanteDacte? remetente;
  final ParticipanteDacte? destinatario;
  final ParticipanteDacte? expedidor;
  final ParticipanteDacte? recebedor;
  final ParticipanteDacte? tomador;

  final String produtoPredominante;
  final String outrasCaracteristicas;
  final double valorTotalCarga;

  final String pesoDeclarado;
  final String volumes;
  final String cubagem;
  final String qtde;

  final List<ComponenteValorDacte> componentes;
  final double valorTotalServico;
  final double valorReceber;

  final String situacaoTributaria;
  final double baseIcms;
  final double aliqIcms;
  final double valorIcms;
  final double redBcIcms;
  final double icmsSt;

  final List<DocumentoOriginarioDacte> documentosOriginarios;
  final String observacoes;

  final String rntrc;
  final String ciot;
  final String dataPrevistaEntrega;

  const DacteData({
    required this.chaveAcesso,
    required this.numero,
    required this.serie,
    required this.naturezaOperacao,
    required this.protocoloAutorizacao,
    required this.dataEmissao,
    required this.modelo,
    required this.modalidadeFrete,
    required this.tipoCte,
    required this.tipoServico,
    required this.tomadorServicoInfo,
    required this.inicioPrestacao,
    required this.fimPrestacao,
    required this.emitente,
    this.remetente,
    this.destinatario,
    this.expedidor,
    this.recebedor,
    this.tomador,
    required this.produtoPredominante,
    required this.outrasCaracteristicas,
    required this.valorTotalCarga,
    required this.pesoDeclarado,
    required this.volumes,
    required this.cubagem,
    required this.qtde,
    required this.componentes,
    required this.valorTotalServico,
    required this.valorReceber,
    required this.situacaoTributaria,
    required this.baseIcms,
    required this.aliqIcms,
    required this.valorIcms,
    required this.redBcIcms,
    required this.icmsSt,
    required this.documentosOriginarios,
    required this.observacoes,
    required this.rntrc,
    required this.ciot,
    required this.dataPrevistaEntrega,
  });
}
