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
    final response = await http.get(Uri.parse('http://localhost:8080/api/employes'));
    if (response.statusCode == 200) {
      setState(() {
        employes = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load employes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Employés'),
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
