class Commande {

  String numpiece;
  String date;
  String client;
  String etat;
  int saisie;
  int commercial;
  int control1;
  int control2;
  //int ver;
  Commande({
    required this.numpiece,
    required this.date,
    required this.client,
    required this.etat,
    required this.saisie,
    required this.commercial,
    required this.control1,
    required this.control2,
   // required this.ver,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
        numpiece: json['numpiece'], date: json['date'],
        client : json['client'], etat : json['etat'],
        saisie : json['saisie'], commercial : json['commercial'],
        control1 : json['control1'], control2 : json['control2'],
       // ver: json['ver']
    );
  }

}