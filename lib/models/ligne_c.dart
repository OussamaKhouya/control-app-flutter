class LigneC {

  String numero;
  String numpiece;
  String designation;
  double quantite;


  LigneC({
    required this.numero,
    required this.numpiece,
    required this.designation,
    required this.quantite,

  });

  factory LigneC.fromJson(Map<String, dynamic> json) {
    return LigneC(
      numero: json['numero'], numpiece: json['numpiece'],
      designation : json['designation'], quantite : json['quantite'],
    );
  }

}