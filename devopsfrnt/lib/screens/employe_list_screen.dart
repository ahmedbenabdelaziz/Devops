import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Employe extends StatefulWidget {
  @override
  _EmployeState createState() => _EmployeState();
}

class _EmployeState extends State<Employe> {
  List<dynamic> employes = [];

  @override
  void initState() {
    super.initState();
    fetchEmployes();
  }

Future<void> fetchEmployes() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/employees'));
  if (response.statusCode == 200) {
    setState(() {
      employes = json.decode(response.body);
      print("Données reçues : $employes");
    });
  } else {
    print("Erreur : ${response.statusCode}");
    throw Exception('Failed to load employes');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: employes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: employes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(

                    title: Text('${employes[index]['nom']} ${employes[index]['prenom']}'),
                    subtitle: Text(employes[index]['poste']),
                  ),
                );
              },
            ),
    );
  }
}
