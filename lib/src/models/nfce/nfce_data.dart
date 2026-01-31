//lib/src/models/nfce/nfce_data.dart

class NfceData {
  final String chaveAcesso;
  final String numero;
  final String serie;
  final String dataEmissao;
  final String protocoloAutorizacao;
  final String urlConsulta;
  final String qrCode;
  final String ambiente; // 1-Produção, 2-Homologação

  final EmitenteNfce emitente;
  final DestinatarioNfce? destinatario;
  final List<ItemNfce> itens;
  final TotaisNfce totais;
  final List<PagamentoNfce> pagamentos;

  const NfceData({
    required this.chaveAcesso,
    required this.numero,
    required this.serie,
    required this.dataEmissao,
    required this.protocoloAutorizacao,
    required this.urlConsulta,
    required this.qrCode,
    required this.ambiente,
    required this.emitente,
    this.destinatario,
    required this.itens,
    required this.totais,
    required this.pagamentos,
  });
}

class EmitenteNfce {
  final String nome;
  final String cnpj;
  final String endereco;

  const EmitenteNfce({
    required this.nome,
    required this.cnpj,
    required this.endereco,
  });
}

class DestinatarioNfce {
  final String? nome;
  final String? cnpjCpf;
  final String? endereco;

  const DestinatarioNfce({
    this.nome,
    this.cnpjCpf,
    this.endereco,
  });
}

class ItemNfce {
  final String codigo;
  final String descricao;
  final double quantidade;
  final String unidade;
  final double valorUnitario;
  final double valorTotal;

  const ItemNfce({
    required this.codigo,
    required this.descricao,
    required this.quantidade,
    required this.unidade,
    required this.valorUnitario,
    required this.valorTotal,
  });
}

class TotaisNfce {
  final double qtdItens;
  final double valorTotalProdutos;
  final double valorDesconto;
  final double valorTotalNota;
  final double valorTributos; // vTotTrib

  const TotaisNfce({
    required this.qtdItens,
    required this.valorTotalProdutos,
    required this.valorDesconto,
    required this.valorTotalNota,
    this.valorTributos = 0,
  });
}

class PagamentoNfce {
  final String forma;
  final double valor;

  const PagamentoNfce({
    required this.forma,
    required this.valor,
  });
}
