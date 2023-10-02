import 'package:flutter/material.dart';

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
  final ligneCmdQuantitePartielController = TextEditingController();
  final ligneCmdQuantiteLivController = TextEditingController();
  final ligneCmdObservationController = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    ligneCmdQuantitePartielController.text = widget.ligneC.quantitePartiel.toString();
    ligneCmdQuantiteLivController.text = widget.ligneC.quantiteLiv.toString();
    ligneCmdObservationController.text = widget.ligneC.observation.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    TextFormField(
                      controller: ligneCmdQuantiteLivController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantité livrée:',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: ligneCmdQuantitePartielController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantité vérifiée:',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: ligneCmdObservationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Observation:',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                          child: const Text("Verrouiller"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
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
    widget.ligneC.quantitePartiel =ligneCmdQuantitePartielController.text;
    widget.ligneC.quantiteLiv = ligneCmdQuantiteLivController.text;
    widget.ligneC.observation = ligneCmdObservationController.text;
    await widget.ligneCCallback(widget.ligneC);
    Navigator.pop(context);
  }
}
