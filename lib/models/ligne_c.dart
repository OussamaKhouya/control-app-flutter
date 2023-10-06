class LigneC {

  String numero;
  String numpiece;
  String designation;
  String quantite;
  String observation1;
  String observation2;
  String quantite1;
  String quantite2;
  String username1;
  String username2;
  String nbrPhoto;


  LigneC({
    required this.numero,
    required this.numpiece,
    required this.designation,
    required this.quantite,
    required this.observation1,
    required this.observation2,
    required this.quantite1,
    required this.quantite2,
    required this.username1,
    required this.username2,
    required this.nbrPhoto,
  });

  factory LigneC.fromJson(Map<String, dynamic> json) {
    return LigneC(
      numero: json['numero'].toString(),
      numpiece: json['numpiece'],
      designation : json['designation'],
      quantite : json['quantite'].toString(),
      observation1 : (json['observation1'] != null) ? json['observation1']:'',
      observation2 : (json['observation2'] != null) ? json['observation2']:'',
      quantite1 : json['quantite1'].toString(),
      quantite2 :  json['quantite2'].toString(),
      username1 :  (json['username1'] != null) ? json['username1']:'',
      username2 :  (json['username2'] != null) ? json['username2']:'',
      nbrPhoto :  json['nbrPhoto'].toString(),
    );
  }

}