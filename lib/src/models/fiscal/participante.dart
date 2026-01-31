/// Representa um participante em um documento fiscal (Emitente, Destinatário, etc.)
class Participante {
  final String? nome;
  final String? nomeFantasia;
  final String? cnpj;
  final String? cpf;
  final String? ie;
  final String? im;
  final String? enderecoLogradouro;
  final String? enderecoNumero;
  final String? enderecoComplemento;
  final String? enderecoBairro;
  final String? enderecoMunicipio;
  final String? enderecoUf;
  final String? enderecoCep;
  final String? enderecoTelefone;
  final String? enderecoEmail;
  final String? enderecoPais;

  String? get cnpjCpf => cnpj ?? cpf;

  const Participante({
    this.nome,
    this.nomeFantasia,
    this.cnpj,
    this.cpf,
    this.ie,
    this.im,
    this.enderecoLogradouro,
    this.enderecoNumero,
    this.enderecoComplemento,
    this.enderecoBairro,
    this.enderecoMunicipio,
    this.enderecoUf,
    this.enderecoCep,
    this.enderecoTelefone,
    this.enderecoEmail,
    this.enderecoPais,
  });
}
