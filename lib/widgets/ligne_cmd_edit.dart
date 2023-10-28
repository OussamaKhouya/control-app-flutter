import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/constants.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../models/lcmd.dart';

class LigneCmdEdit extends StatefulWidget {
  final LCmd ligneC;
  final Function ligneCCallback;

  const LigneCmdEdit(this.ligneC, this.ligneCCallback, {Key? key})
      : super(key: key);

  @override
  _LigneCmdEditState createState() => _LigneCmdEditState();
}

class _LigneCmdEditState extends State<LigneCmdEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ligneCmdQuantite1Controller = TextEditingController();
  final ligneCmdQuantite2Controller = TextEditingController();
  final ligneCmdObservation1Controller = TextEditingController();
  final ligneCmdObservation2Controller = TextEditingController();

  final lcBoite1Controller = TextEditingController();
  final lcBoite2Controller = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    ligneCmdQuantite1Controller.text = widget.ligneC.a_bcc_quch1;
    ligneCmdQuantite2Controller.text = widget.ligneC.a_bcc_quch2;
    ligneCmdObservation1Controller.text = widget.ligneC.a_bcc_obs1;
    ligneCmdObservation2Controller.text = widget.ligneC.a_bcc_obs2;
    lcBoite1Controller.text = widget.ligneC.a_bcc_boch1;
    lcBoite2Controller.text = widget.ligneC.a_bcc_boch2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getPermissions();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.97,
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              '${widget.ligneC.a_bcc_nupi} - ${widget.ligneC.a_bcc_num}',
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.ligneC.a_bcc_lib,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Quantité: ${widget.ligneC.a_bcc_qua}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Boites : ${widget.ligneC.a_bcc_boi}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Coefficient : ${widget.ligneC.a_bcc_coe}",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Visibility(
                      visible: SHOW_TXT_Q1,
                      child: TextFormField(
                        readOnly: !ENABLE_TXT_Q1,
                        controller: ligneCmdQuantite1Controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantité 1:',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?(\d+\.?\d{0,4})?')),
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'La quantité est requis';
                          }
                          final newValue = double.tryParse(value);

                          if (newValue == null) {
                            return 'Format de la quantité invalide';
                          }
                        },
                        onChanged: (text){
                          setState(() {
                            errorMessage = '';
                          });
                          if(text.isEmpty) text = '0';
                          lcBoite1Controller.text = (double.parse(text) ~/ double.parse(widget.ligneC.a_bcc_coe)).toString();

                          },
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                      visible: SHOW_TXT_Q1,
                      child: TextFormField(
                        readOnly: !ENABLE_TXT_Q1,
                        controller: lcBoite1Controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Boites Chargées 1:',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?(\d+\.?\d{0,4})?')),
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'La N boites est requis';
                          }
                          final newValue = double.tryParse(value);

                          if (newValue == null) {
                            return 'Format de N boites invalide';
                          }
                        },
                        onChanged: (text){
                          setState(() {
                            errorMessage = '';
                          });
                          if(text.isEmpty) text = '0';
                          ligneCmdQuantite1Controller.text = (double.parse(text) * double.parse(widget.ligneC.a_bcc_coe)).toString();

                        },
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                      visible: SHOW_TXT_OBS1,
                      child: TextFormField(
                        readOnly: !ENABLE_TXT_OBS1,
                        controller: ligneCmdObservation1Controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Observation 1:',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9\s.,_-]+$')),
                        ],
                        onChanged: (text) => setState(() => errorMessage = ''),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                      visible: SHOW_TXT_Q2,
                      child: TextFormField(
                        readOnly: !ENABLE_TXT_Q2,
                        controller: ligneCmdQuantite2Controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantité 2:',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?(\d+\.?\d{0,4})?')),
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'La quantité est requis';
                          }
                          final newValue = double.tryParse(value);

                          if (newValue == null) {
                            return 'Format de la quantité invalide';
                          }
                        },
                          onChanged: (text){
                            setState(() {
                              errorMessage = '';
                            });
                            if(text.isEmpty) text = '0';
                            lcBoite2Controller.text = (double.parse(text) ~/ double.parse(widget.ligneC.a_bcc_coe)).toString();

                          },

                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                      visible: SHOW_TXT_Q2,
                      child: TextFormField(
                        readOnly: !ENABLE_TXT_Q2,
                        controller: lcBoite2Controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Boites Chargées 2:',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?(\d+\.?\d{0,4})?')),
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'La N boites est requis';
                          }
                          final newValue = double.tryParse(value);

                          if (newValue == null) {
                            return 'Format de N boites invalide';
                          }
                        },
                        onChanged: (text){
                          setState(() {
                            errorMessage = '';
                          });
                          if(text.isEmpty) text = '0';
                          ligneCmdQuantite2Controller.text = (double.parse(text) * double.parse(widget.ligneC.a_bcc_coe)).toString();

                        },
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                      visible: SHOW_TXT_OBS2,
                      child: TextFormField(
                        readOnly: !ENABLE_TXT_OBS2,
                        controller: ligneCmdObservation2Controller,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9\s.,_-]+$')),
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Observation 2:',
                        ),
                        onChanged: (text) => setState(() => errorMessage = ''),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: SHOW_BTN_MODIF,
                          child: ElevatedButton(
                            onPressed: () {
                              updateLigneC(context);
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                            child: const Text("Modifier"),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                            MaterialStatePropertyAll(Colors.red)),
                        child: const Text("Annuler"),
                      ),
                    ],
                  ),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Future updateLigneC(context) async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    widget.ligneC.a_bcc_quch1 = ligneCmdQuantite1Controller.text;
    widget.ligneC.a_bcc_quch2 = ligneCmdQuantite2Controller.text;
    widget.ligneC.a_bcc_obs1 = ligneCmdObservation1Controller.text;
    widget.ligneC.a_bcc_obs2 = ligneCmdObservation2Controller.text;
    widget.ligneC.a_bcc_boch1 = lcBoite1Controller.text;
    widget.ligneC.a_bcc_boch2 = lcBoite2Controller.text;
    widget
        .ligneCCallback(widget.ligneC)
        .then((category) => Navigator.pop(context))
        .catchError((exception) {
      setState(() {
        errorMessage = exception.toString();
      });
    });
  }

  // Initialize Permissions
  late bool SHOW_TXT_Q1, SHOW_TXT_Q2, SHOW_TXT_OBS1, SHOW_TXT_OBS2;
  late bool ENABLE_TXT_Q1, ENABLE_TXT_Q2, ENABLE_TXT_OBS1, ENABLE_TXT_OBS2;
  late bool SHOW_BTN_MODIF;

  void getPermissions() {
    final provider = Provider.of<AuthProvider>(context);
    Map<String, dynamic> permissions = provider.permissions;

    SHOW_TXT_Q1 = permissions[PermConstants.SHOW_TXT_Q1]!;
    SHOW_TXT_Q2 = permissions[PermConstants.SHOW_TXT_Q2]!;
    SHOW_TXT_OBS1 = permissions[PermConstants.SHOW_TXT_OBS1]!;
    SHOW_TXT_OBS2 = permissions[PermConstants.SHOW_TXT_OBS2]!;

    ENABLE_TXT_Q1 = permissions[PermConstants.ENABLE_TXT_Q1]!;
    ENABLE_TXT_Q2 = permissions[PermConstants.ENABLE_TXT_Q2]!;
    ENABLE_TXT_OBS1 = permissions[PermConstants.ENABLE_TXT_OBS1]!;
    ENABLE_TXT_OBS2 = permissions[PermConstants.ENABLE_TXT_OBS2]!;

    SHOW_BTN_MODIF = permissions[PermConstants.SHOW_BTN_MODIF]!;
  }
}
