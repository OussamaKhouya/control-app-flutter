class Commande {

  String numpiece;
  DateTime date;
  String client;
  String etat;
  bool saisie;
  bool commercial;
  bool control1;
  bool control2;

  Commande({
    required this.numpiece,
    required this.date,
    required this.client,
    required this.etat,
    required this.saisie,
    required this.commercial,
    required this.control1,
    required this.control2
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
        numpiece: json['numpiece'], date: json['date'],
        client : json['client'], etat : json['etat'],
        saisie : json['saisie'], commercial : json['commercial'],
        control1 : json['control1'], control2 : json['control2'],
    );
  }

}