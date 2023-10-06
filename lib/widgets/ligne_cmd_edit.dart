import 'package:flutter/material.dart';
import 'package:flutter_app/models/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/auth_provider.dart';

import '../models/user.dart';
import '../models/ligne_c.dart';

class LigneCmdEdit extends StatefulWidget {
  final LigneC ligneC;
  final Function ligneCCallback;

  LigneCmdEdit(this.ligneC, this.ligneCCallback, {Key? key}) : super(key: key);

  @override
  _LigneCmdEditState createState() => _LigneCmdEditState();
}

class _LigneCmdEditState extends State<LigneCmdEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ligneCmdQuantite1Controller = TextEditingController();
  final ligneCmdQuantite2Controller = TextEditingController();
  final ligneCmdObservation1Controller = TextEditingController();
  final ligneCmdObservation2Controller = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    ligneCmdQuantite1Controller.text = widget.ligneC.quantite1;
    ligneCmdQuantite2Controller.text = widget.ligneC.quantite2;
    ligneCmdObservation1Controller.text = widget.ligneC.observation1;
    ligneCmdObservation2Controller.text = widget.ligneC.observation2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getPermissions();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.97,
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '${widget.ligneC.numpiece} - ${widget.ligneC.numero}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 21,
              ),
              Text(
                widget.ligneC.designation,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 21,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Quantité demandé: ${widget.ligneC.quantite}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Visibility(visible: showQ1, child: TextFormField(
                      controller: ligneCmdQuantite1Controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantité 1:',
                      ),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(visible: showObs1, child:TextFormField(
                      controller: ligneCmdObservation1Controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Observation 1:',
                      ),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(visible: showQ2, child:TextFormField(
                      controller: ligneCmdQuantite2Controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantité 2:',
                      ),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(visible: showObs2, child:TextFormField(
                      controller: ligneCmdObservation2Controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Observation 2:',
                      ),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            updateLigneC(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue)),
                          child: const Text("Modifier"),
                        ),
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future updateLigneC(context) async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    print(widget.ligneC.quantite1);
    widget.ligneC.quantite1 = ligneCmdQuantite1Controller.text;
    widget.ligneC.quantite2 = ligneCmdQuantite2Controller.text;
    widget.ligneC.observation1 = ligneCmdObservation1Controller.text;
    widget.ligneC.observation2 = ligneCmdObservation2Controller.text;
    await widget.ligneCCallback(widget.ligneC);
    Navigator.pop(context);
  }

  late bool showQ1, showQ2, showObs1, showObs2;
  void getPermissions(){
    final provider = Provider.of<AuthProvider>(context);
    String role = provider.currUser.role;

    showQ1 = false; showQ2 = false; showObs1 = false; showObs2 = false;

    if (role == RoleConstants.control1) {
      showQ1 = true; showQ2 = false; showObs1 = true; showObs2 = false;
    }
    if (role == RoleConstants.control2) {
      showQ1 = false; showQ2 = true; showObs1 = false; showObs2 = true;
    }
  }
}
