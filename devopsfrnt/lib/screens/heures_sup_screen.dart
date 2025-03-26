import 'package:flutter/material.dart';

class HeuresSupScreen extends StatefulWidget {
  const HeuresSupScreen({super.key});

  @override
  State<HeuresSupScreen> createState() => _HeuresSupScreenState();
}
//fdfgfd
class _HeuresSupScreenState extends State<HeuresSupScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String result = '';
  bool isLoading = false;

  void calculerHeuresSup() {
    setState(() => isLoading = true);

    // Simulated calculation based on the start and end dates
    try {
      final startDate = DateTime.parse(_startDateController.text);
      final endDate = DateTime.parse(_endDateController.text);
      final duration = endDate.difference(startDate).inHours;

      if (duration > 0) {
        setState(() {
          result = 'Heures Supplémentaires: ${duration - 40} heures'; // Example: 40 hours regular work week
          isLoading = false;
        });
      } else {
        setState(() {
          result = 'Erreur: La date de fin doit être après la date de début';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        result = 'Erreur de format de date';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul des Heures'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _startDateController,
              decoration: const InputDecoration(
                labelText: 'Date de début',
                hintText: 'AAAA-MM-JJ',
              ),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _endDateController,
              decoration: const InputDecoration(
                labelText: 'Date de fin',
                hintText: 'AAAA-MM-JJ',
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : calculerHeuresSup,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculer'),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
