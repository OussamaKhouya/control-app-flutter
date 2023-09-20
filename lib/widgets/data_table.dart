import 'package:flutter/material.dart';


class DataTableExampleApp extends StatelessWidget {
  const DataTableExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('DataTable Sample')),
        body: const DataTableExample(),
      ),
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Scrollbar(
        controller:  ScrollController(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Expanded(
                  child: Text(
                    'NumeroC',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Libelle',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'DateC',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Client',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Voir',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              )
            ],
            rows:  <DataRow>[
              DataRow(
                cells: <DataCell>[
                  const DataCell(Text('A0102030104')),
                  const DataCell(Text('Commande 13')),
                  const DataCell(Text('14/09/23')),
                  const DataCell(Text('Ahmed Alami')),
                  DataCell(
                      GestureDetector(
                        child: const Icon(Icons.input),
                        onTap: (){
                          Navigator.pushNamed(context, '/detailsCmd');
                        },
                      )
                  ),
                ],
              ),

            ],
          ),
        ) ,
      );


  }
}
