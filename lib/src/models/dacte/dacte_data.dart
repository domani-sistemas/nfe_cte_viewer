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
  });

  String get enderecoCompleto =>
      '$logradouro, $numero - $bairro - $municipio/$uf';
}

class TotaisDacte {
  final double valorTotalServico;
  final double valorReceber;
  final double baseIcms;
  final double aliqIcms;
  final double valorIcms;

  const TotaisDacte({
    required this.valorTotalServico,
    required this.valorReceber,
    required this.baseIcms,
    required this.aliqIcms,
    required this.valorIcms,
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

  final String municipioOrigem;
  final String ufOrigem;
  final String municipioDestino;
  final String ufDestino;

  final ParticipanteDacte emitente;
  final ParticipanteDacte? remetente;
  final ParticipanteDacte? destinatario;
  final ParticipanteDacte? expedidor;
  final ParticipanteDacte? recebedor;
  final ParticipanteDacte? tomador;

  final String produtoPredominante;
  final String outrasCaracteristicas;
  final double pesoBruto;
  final double pesoLiquido;
  final double valorCarga;

  final TotaisDacte totais;
  final String informacoesComplementares;

  const DacteData({
    required this.chaveAcesso,
    required this.numero,
    required this.serie,
    required this.naturezaOperacao,
    required this.protocoloAutorizacao,
    required this.dataEmissao,
    required this.modelo,
    required this.modalidadeFrete,
    required this.municipioOrigem,
    required this.ufOrigem,
    required this.municipioDestino,
    required this.ufDestino,
    required this.emitente,
    this.remetente,
    this.destinatario,
    this.expedidor,
    this.recebedor,
    this.tomador,
    required this.produtoPredominante,
    required this.outrasCaracteristicas,
    required this.pesoBruto,
    required this.pesoLiquido,
    required this.valorCarga,
    required this.totais,
    required this.informacoesComplementares,
  });
}
