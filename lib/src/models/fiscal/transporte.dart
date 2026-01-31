/// Representa as informações de transporte
class Transporte {
  final String? modFrete;
  final String? transportadoraNome;
  final String? transportadoraCnpj;
  final String? transportadoraEndereco;
  final String? transportadoraMunicipio;
  final String? transportadoraUf;
  final String? veiculoPlaca;
  final String? veiculoUf;
  final String? veiculoRntrc;
  final String? volQuantidade;
  final String? volEspecie;
  final String? volMarca;
  final String? volNumeracao;
  final double? pesoLiquido;
  final double? pesoBruto;
  final double? valorFrete;
  final double? valorSeguro;
  final String? ciot;

  const Transporte({
    this.modFrete,
    this.transportadoraNome,
    this.transportadoraCnpj,
    this.transportadoraEndereco,
    this.transportadoraMunicipio,
    this.transportadoraUf,
    this.veiculoPlaca,
    this.veiculoUf,
    this.veiculoRntrc,
    this.volQuantidade,
    this.volEspecie,
    this.volMarca,
    this.volNumeracao,
    this.pesoLiquido,
    this.pesoBruto,
    this.valorFrete,
    this.valorSeguro,
    this.ciot,
  });
}
