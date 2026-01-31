//lib/src/models/danfe/danfe_data.dart
class EmitenteDanfe {
  final String nome;
  final String logradouro;
  final String numero;
  final String bairro;
  final String municipio;
  final String uf;
  final String cep;
  final String cnpj;
  final String ie;
  final String fone;

  const EmitenteDanfe({
    required this.nome,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.municipio,
    required this.uf,
    required this.cep,
    required this.cnpj,
    required this.ie,
    required this.fone,
  });

  String get enderecoCompleto =>
      '$logradouro, $numero - $bairro - $municipio/$uf';
}

class DestinatarioDanfe {
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
  final String dataEmissao;

  const DestinatarioDanfe({
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
    required this.dataEmissao,
  });

  String get enderecoCompleto =>
      '$logradouro, $numero - $bairro - $municipio/$uf';
}

class ItemDanfe {
  final String codigo;
  final String descricao;
  final String ncm;
  final String cfop;
  final String cst;
  final String unidade;
  final double quantidade;
  final double valorUnitario;
  final double valorTotal;
  final double baseIcms;
  final double valorIcms;
  final double valorIpi;
  final double aliqIcms;
  final double aliqIpi;

  const ItemDanfe({
    required this.codigo,
    required this.descricao,
    required this.ncm,
    required this.cfop,
    required this.cst,
    required this.unidade,
    required this.quantidade,
    required this.valorUnitario,
    required this.valorTotal,
    required this.baseIcms,
    required this.valorIcms,
    required this.valorIpi,
    required this.aliqIcms,
    required this.aliqIpi,
  });
}

class TotaisDanfe {
  final double baseIcms;
  final double valorIcms;
  final double baseIcmsSt;
  final double valorIcmsSt;
  final double valorProdutos;
  final double valorFrete;
  final double valorSeguro;
  final double valorDesconto;
  final double outrasDespesas;
  final double valorIpi;
  final double valorTotalNota;

  const TotaisDanfe({
    required this.baseIcms,
    required this.valorIcms,
    required this.baseIcmsSt,
    required this.valorIcmsSt,
    required this.valorProdutos,
    required this.valorFrete,
    required this.valorSeguro,
    required this.valorDesconto,
    required this.outrasDespesas,
    required this.valorIpi,
    required this.valorTotalNota,
  });
}

class TransporteDanfe {
  final String modalidadeFrete;
  final String transportadorNome;
  final String transportadorCnpjCpf;
  final String transportadoraIe;
  final String transportadoraEndereco;
  final String transportadoraMunicipio;
  final String transportadoraUf;
  final String placaVeiculo;
  final String ufVeiculo;
  final String rntrc;
  final String quantidade;
  final String especie;
  final String marca;
  final String numeracao;
  final double pesoBruto;
  final double pesoLiquido;

  const TransporteDanfe({
    required this.modalidadeFrete,
    required this.transportadorNome,
    required this.transportadorCnpjCpf,
    required this.transportadoraIe,
    required this.transportadoraEndereco,
    required this.transportadoraMunicipio,
    required this.transportadoraUf,
    required this.placaVeiculo,
    required this.ufVeiculo,
    required this.rntrc,
    required this.quantidade,
    required this.especie,
    required this.marca,
    required this.numeracao,
    required this.pesoBruto,
    required this.pesoLiquido,
  });
}

class DadosAdicionaisDanfe {
  final String informacoesFisco;
  final String informacoesComplementares;

  const DadosAdicionaisDanfe({
    required this.informacoesFisco,
    required this.informacoesComplementares,
  });
}

class DanfeData {
  final String chaveAcesso;
  final String numero;
  final String serie;
  final String naturezaOperacao;
  final String protocoloAutorizacao;
  final String dataEmissao;
  final bool isSaida;

  final EmitenteDanfe emitente;
  final DestinatarioDanfe destinatario;
  final List<ItemDanfe> itens;
  final TotaisDanfe totais;
  final TransporteDanfe transporte;
  final DadosAdicionaisDanfe dadosAdicionais;

  const DanfeData({
    required this.chaveAcesso,
    required this.numero,
    required this.serie,
    required this.naturezaOperacao,
    required this.protocoloAutorizacao,
    required this.dataEmissao,
    required this.isSaida,
    required this.emitente,
    required this.destinatario,
    required this.itens,
    required this.totais,
    required this.transporte,
    required this.dadosAdicionais,
  });
}
