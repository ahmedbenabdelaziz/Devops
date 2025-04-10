import 'package:flutter/material.dart';

class OvertimeCalculatorPage extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calcul des Heures Supplémentaires'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entrez les détails pour calculer les heures supplémentaires:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: hoursController,
              decoration: InputDecoration(
                labelText: 'Nombre d\'heures supplémentaires',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Logique de calcul des heures supplémentaires
                final hours = double.tryParse(hoursController.text);
                final overtime = hours != null ? hours * 1.5 : 0; // Exemple simple
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Heures Supplémentaires'),
                    content: Text('Le calcul des heures supplémentaires est : $overtime heures'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Calculer'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
