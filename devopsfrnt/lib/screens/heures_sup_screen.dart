import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeuresSupScreen extends StatefulWidget {
  const HeuresSupScreen({super.key});

  @override
  State<HeuresSupScreen> createState() => _HeuresSupScreenState();
}

class _HeuresSupScreenState extends State<HeuresSupScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  List<dynamic> employees = [];
  int? selectedEmployeeId;
  Map<String, dynamic>? calculationResult;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/employees'));
      if (response.statusCode == 200) {
        setState(() {
          employees = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Erreur chargement employés: $e');
    }
  }

  Future<void> calculateOvertime() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      calculationResult = null;
    });

    try {
      final response = await http.get(Uri.parse(
        'http://localhost:5000/api/overtime/$selectedEmployeeId'
        '/${_startDateController.text}/${_endDateController.text}'
      ));

      if (response.statusCode == 200) {
        setState(() {
          calculationResult = json.decode(response.body);
        });
      } else {
        setState(() {
          errorMessage = 'Erreur de calcul: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul des Heures Supplémentaires'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchEmployees,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<int>(
              value: selectedEmployeeId,
              hint: const Text('Sélectionner un employé'),
              items: employees.map((employee) {
                return DropdownMenuItem<int>(
                  value: employee['id'],
                  child: Text('${employee['prenom']} ${employee['nom']}'),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedEmployeeId = value),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Date de début',
                hintText: 'AAAA-MM-JJ',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _startDateController.text = date.toIso8601String().split('T')[0];
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'Date de fin',
                hintText: 'AAAA-MM-JJ',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  _endDateController.text = date.toIso8601String().split('T')[0];
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading || selectedEmployeeId == null 
                  ? null 
                  : calculateOvertime,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('CALCULER', style: TextStyle(fontSize: 18)),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red[700], fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (calculationResult != null)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Résultat du calcul:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Type de jour')),
                        DataColumn(label: Text('Heures')),
                        DataColumn(label: Text('Taux')),
                        DataColumn(label: Text('Total')),
                      ],
                      rows: calculationResult!['details'].map<DataRow>((detail) {
                        return DataRow(cells: [
                          DataCell(Text(detail['dayType'])),
                          DataCell(Text(detail['hours'].toString())),
                          DataCell(Text('x${detail['rate']}')),
                          DataCell(Text('${detail['total']} €')),
                        ]);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Total général: ${calculationResult!['total']} €',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}