class LigneC {

  String numero;
  String numpiece;
  String designation;
  String quantite;
  String observation;
  String quantitePartiel;
  String quantiteLiv;


  LigneC({
    required this.numero,
    required this.numpiece,
    required this.designation,
    required this.quantite,
    required this.observation,
    required this.quantitePartiel,
    required this.quantiteLiv,
  });

  factory LigneC.fromJson(Map<String, dynamic> json) {
    return LigneC(
      numero: json['numero'].toString(),
      numpiece: json['numpiece'],
      designation : json['designation'],
      quantite : json['quantite'].toString(),
      observation : json['observation'],
      quantitePartiel : json['quantitePartiel'].toString(),
      quantiteLiv :  json['quantiteLiv'].toString(),
    );
  }

}