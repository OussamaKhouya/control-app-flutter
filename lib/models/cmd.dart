class Cmd {
  String bcc_nupi;
  String bcc_dat;
  String bcc_dach1;
  String bcc_dach2;
  String bcc_lcli;
  String bcc_lrep;
  String bcc_lexp;
  String bcc_veh;
  String bcc_eta;
  bool bcc_val;
  String bcc_usr_sai;
  String bcc_usr_com;
  String bcc_usr_con1;
  String bcc_usr_con2;
  String bcc_usr_sup;


  Cmd({
    required this.bcc_nupi,
    required this.bcc_dat,
    required this.bcc_dach1,
    required this.bcc_dach2,
    required this.bcc_lcli,
    required this.bcc_lrep,
    required this.bcc_lexp,
    required this.bcc_veh,
    required this.bcc_eta,
    required this.bcc_val,
    required this.bcc_usr_sai,
    required this.bcc_usr_com,
    required this.bcc_usr_con1,
    required this.bcc_usr_con2,
    required this.bcc_usr_sup,
  });

  factory Cmd.fromJson(Map<String, dynamic> json) {
    return Cmd(
      bcc_nupi: json['bcc_nupi'],
      bcc_dat: json['bcc_dat'],
      bcc_dach1: json['bcc_dach1'],
      bcc_dach2: json['bcc_dach2'],
      bcc_lcli: json['bcc_lcli'],
      bcc_lrep: json['bcc_lrep'],
      bcc_lexp: json['bcc_lexp'],
      bcc_veh: json['bcc_veh'],
      bcc_eta: json['bcc_eta'],
      bcc_val: json['bcc_val'] == 1,
      bcc_usr_sai: json['bcc_usr_sai'],
      bcc_usr_com: json['bcc_usr_com'],
      bcc_usr_con1: json['bcc_usr_con1'],
      bcc_usr_con2: json['bcc_usr_con2'],
      bcc_usr_sup: json['bcc_usr_sup'],
    );
  }
}
