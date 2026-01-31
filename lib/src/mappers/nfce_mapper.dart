//lib/src/mappers/nfce_mapper.dart

import 'package:intl/intl.dart';
import '../models/fiscal/documento_fiscal.dart';
import '../models/nfce/nfce_data.dart';

class NfceMapper {
  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

  static NfceData fromDomain(DocumentoFiscal doc) {
    return NfceData(
      chaveAcesso: doc.chaveAcesso ?? '',
      numero: doc.numero ?? '',
      serie: doc.serie ?? '',
      dataEmissao:
          doc.dataEmissao != null ? _dateFormat.format(doc.dataEmissao!) : '',
      protocoloAutorizacao: doc.protocoloAutorizacao ?? '',
      urlConsulta: doc.urlConsulta ?? '',
      qrCode: doc.qrCode ?? '',
      ambiente: doc.tipoAmbiente ?? '1',
      emitente: EmitenteNfce(
        nome: doc.emitente?.nome ?? '',
        cnpj: doc.emitente?.cnpj ?? '',
        endereco: _formatEndereco(doc.emitente),
      ),
      destinatario:
          doc.destinatario?.nome != null || doc.destinatario?.cnpjCpf != null
              ? DestinatarioNfce(
                  nome: doc.destinatario?.nome,
                  cnpjCpf: doc.destinatario?.cnpjCpf,
                  endereco: _formatEndereco(doc.destinatario),
                )
              : null,
      itens: doc.itens
          .map((i) => ItemNfce(
                codigo: i.codigo ?? '',
                descricao: i.descricao ?? '',
                quantidade: i.quantidade ?? 0.0,
                unidade: i.unidade ?? '',
                valorUnitario: i.valorUnitario ?? 0.0,
                valorTotal: i.valorTotal ?? 0.0,
              ))
          .toList(),
      totais: TotaisNfce(
        qtdItens: doc.itens.length.toDouble(),
        valorTotalProdutos: doc.valorTotalProdutos ?? 0.0,
        valorDesconto: 0.0, // TODO: Extract discount if needed
        valorTotalNota: doc.valorTotalNota ?? 0.0,
        valorTributos: 0.0, // TODO: Extract from infAdic or total
      ),
      pagamentos: doc.pagamentos
          .map((p) => PagamentoNfce(
                forma: _mapFormaPagamento(p.forma),
                valor: p.valor,
              ))
          .toList(),
    );
  }

  static String _formatEndereco(dynamic p) {
    if (p == null) return '';
    return '${p.enderecoLogradouro ?? ''}, ${p.enderecoNumero ?? ''} - ${p.enderecoBairro ?? ''}, ${p.enderecoMunicipio ?? ''}/${p.enderecoUf ?? ''}';
  }

  static String _mapFormaPagamento(String tPag) {
    switch (tPag) {
      case '01':
        return 'Dinheiro';
      case '02':
        return 'Cheque';
      case '03':
        return 'Cartão de Crédito';
      case '04':
        return 'Cartão de Débito';
      case '05':
        return 'Crédito Loja';
      case '10':
        return 'Vale Alimentação';
      case '11':
        return 'Vale Refeição';
      case '12':
        return 'Vale Presente';
      case '13':
        return 'Vale Combustível';
      case '15':
        return 'Boleto Bancário';
      case '17':
        return 'PIX';
      case '90':
        return 'Sem pagamento';
      default:
        return 'Outros';
    }
  }
}
