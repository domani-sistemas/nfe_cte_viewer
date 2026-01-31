/// Representa os impostos de um item ou documento
class Impostos {
  final double? vbc;
  final double? vicms;
  final double? vbcst;
  final double? vicmsst;
  final double? vipi;
  final double? pcms;
  final double? vpis;
  final double? vcofins;

  const Impostos({
    this.vbc,
    this.vicms,
    this.vbcst,
    this.vicmsst,
    this.vipi,
    this.pcms,
    this.vpis,
    this.vcofins,
  });
}
