class LCmd {
  String a_bcc_num;
  String a_bcc_nupi;
  String a_bcc_lib;
  String a_bcc_dep;
  String a_bcc_qua;
  String a_bcc_coe;
  String a_bcc_boi;
  String a_bcc_quch1;
  String a_bcc_boch1;
  String a_bcc_obs1;
  String a_bcc_quch2;
  String a_bcc_boch2;
  String a_bcc_obs2;
  String nph1;
  String nph2;
  String phc;
  String phb;


  LCmd({
    required this.a_bcc_num,
    required this.a_bcc_nupi,
    required this.a_bcc_lib,
    required this.a_bcc_dep,
    required this.a_bcc_qua,
    required this.a_bcc_coe,
    required this.a_bcc_boi,
    required this.a_bcc_quch1,
    required this.a_bcc_boch1,
    required this.a_bcc_obs1,
    required this.a_bcc_quch2,
    required this.a_bcc_boch2,
    required this.a_bcc_obs2,
    required this.nph1,
    required this.nph2,
    required this.phc,
    required this.phb,
  });

  factory LCmd.fromJson(Map<String, dynamic> json) {
    return LCmd(
      a_bcc_num : (json['a_bcc_num'] != null) ? json['a_bcc_num'].toString():'',
      a_bcc_nupi : (json['a_bcc_nupi'] != null) ? json['a_bcc_nupi'].toString():'',
      a_bcc_lib : (json['a_bcc_lib'] != null) ? json['a_bcc_lib'].toString():'',
      a_bcc_dep : (json['a_bcc_dep'] != null) ? json['a_bcc_dep'].toString():'',
      a_bcc_qua : (json['a_bcc_qua'] != null) ? json['a_bcc_qua'].toString():'',
      a_bcc_coe : (json['a_bcc_coe'] != null) ? json['a_bcc_coe'].toString():'',
      a_bcc_boi : (json['a_bcc_boi'] != null) ? json['a_bcc_boi'].toString():'',
      a_bcc_quch1 : (json['a_bcc_quch1'] != null) ? json['a_bcc_quch1'].toString():'',
      a_bcc_boch1 : (json['a_bcc_boch1'] != null) ? json['a_bcc_boch1'].toString():'',
      a_bcc_obs1 : (json['a_bcc_obs1'] != null) ? json['a_bcc_obs1'].toString():'',
      a_bcc_quch2 : (json['a_bcc_quch2'] != null) ? json['a_bcc_quch2'].toString():'',
      a_bcc_boch2 : (json['a_bcc_boch2'] != null) ? json['a_bcc_boch2'].toString():'',
      a_bcc_obs2 : (json['a_bcc_obs2'] != null) ? json['a_bcc_obs2'].toString():'',
      nph1 : (json['nph1'] != null) ? json['nph1'].toString():'',
      nph2 : (json['nph2'] != null) ? json['nph2'].toString():'',
      phc : (json['phc'] != null) ? json['phc'].toString():'',
      phb : (json['phb'] != null) ? json['phb'].toString():'',
    );
  }



}