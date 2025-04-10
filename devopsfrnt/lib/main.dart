import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application DevOps',
      theme: ThemeData(
        primaryColor: Color(0xFF6C5CE7),
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord DevOps',
            style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C5CE7), Color(0xFF8477FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Ajoutez l'image de fond ici
          Positioned.fill(
            child: Image.asset(
              'assets/images/shutterstock_721758364.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Fonctionnalités Principales'),
                SizedBox(height: 30),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.people_alt_rounded,
                  title: 'Gestion des Employés',
                  subtitle: 'Consulter et gérer le personnel',
                  color: [Color(0xFF6C5CE7), Color(0xFF8477FF)],
                  route: EmployeeListPage(),
                ),
                SizedBox(height: 20),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.access_time_filled_rounded,
                  title: 'Calcul des Heures',
                  subtitle: 'Gestion des heures supplémentaires',
                  color: [Color(0xFFFF7675), Color(0xFFFD9774)],
                  route: OvertimeCalculatorPage(),
                ),
              ],
            ),
          ),
        ],
      ),
   
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> color,
    required Widget route,
  }) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => route)),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color[0].withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            )
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 15),
            Text(title),
            SizedBox(height: 5),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }
}


class Employee {
  final String id;
  final String name;
  final String position;

  Employee({required this.id, required this.name, required this.position});

factory Employee.fromJson(Map<String, dynamic> json) {
  return Employee(
    id: json['id'].toString(),
    name: '${json['prenom']} ${json['nom']}',
    position: json['poste'],
  );
}

}

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> employees = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    print("fff");
    fetchEmployees();
    print("ww");
  }
Future<void> fetchEmployees() async {
  try {
    print("object");
final response = await http.get(Uri.parse('http://localhost:5000/api/employees'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print('ra');
      setState(() {
        employees = data.map((e) => Employee.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Erreur de chargement: ${response.statusCode} - ${response.body}';
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Erreur de connexion au serveur: $e';
      isLoading = false;
    });
  }
}

  Future<void> deleteEmployee(String id) async {
    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:5000/api/employees/$id'));
      if (response.statusCode == 200) {
        setState(() {
          employees.removeWhere((e) => e.id == id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de la suppression')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Employés'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
        backgroundColor: Color(0xFF6C5CE7),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/shutterstock_721758364.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchField(),
                SizedBox(height: 20),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : errorMessage.isNotEmpty
                          ? Center(child: Text(errorMessage))
                          : ListView.builder(
                              itemCount: employees.length,
                              itemBuilder: (context, index) =>
                                  _buildEmployeeTile(employees[index], index == employees.length - 1),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Rechercher un employé...',
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildEmployeeTile(Employee employee, bool isLast) {
    final initials = employee.name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase())
        .take(2)
        .join();

    return Dismissible(
      key: Key(employee.id),
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await deleteEmployee(employee.id);
        setState(() => employees.removeWhere((e) => e.id == employee.id));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C5CE7), Color(0xFF8477FF)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          title: Text(employee.name, style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(employee.position),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ),
      ),
    );
  }
}


class OvertimeCalculatorPage extends StatefulWidget {
  @override
  _OvertimeCalculatorPageState createState() => _OvertimeCalculatorPageState();
}

class _OvertimeCalculatorPageState extends State<OvertimeCalculatorPage> {
  final TextEditingController hoursController = TextEditingController();
  DateTime? selectedDate;
  double overtimeResult = 0;
  Employee? selectedEmployee;

  List<Employee> employees = [
    Employee(id: '1', name: 'Ahmed', position: 'Développeur'),
    Employee(id: '2', name: 'Chaima', position: 'Manager'),
    Employee(id: '3', name: 'Hbib', position: 'Designer'),
    Employee(id: '4', name: 'Adem', position: 'DevOps'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculateur d\'Heures')),
      body: Stack(
        children: [
          // Ajoutez l'image de fond ici
          Positioned.fill(
            child: Image.asset(
 'assets/images/shutterstock_721758364.png',              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildEmployeePicker(),
                SizedBox(height: 20),
                _buildDatePicker(),
                SizedBox(height: 20),
                _buildInputField(),
                SizedBox(height: 30),
                _buildCalculateButton(),
                SizedBox(height: 30),
                _buildResultCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeePicker() {
    return DropdownButton<Employee>(
      hint: Text('Sélectionner un Employé'),
      value: selectedEmployee,
      onChanged: (Employee? newValue) {
        setState(() {
          selectedEmployee = newValue;
        });
      },
      items: employees.map((Employee employee) {
        return DropdownMenuItem<Employee>(
          value: employee,
          child: Text(employee.name),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) setState(() => selectedDate = date);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF6C5CE7)),
            SizedBox(width: 15),
            Text(
              selectedDate == null
                  ? 'Sélectionnez une date'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: hoursController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
      decoration: InputDecoration(
        labelText: 'Heures supplémentaires',
        prefixIcon: Icon(Icons.access_time, color: Color(0xFF6C5CE7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton.icon(
      icon: Icon(Icons.calculate),
      label: Text('Calculer'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: _calculateOvertime,
    );
  }

  Widget _buildResultCard() {
    return Visibility(
      visible: overtimeResult > 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF8477FF)],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text('Résultat du Calcul',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            Text('${overtimeResult.toStringAsFixed(2)} heures',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _calculateOvertime() {
    if (selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez sélectionner un employé'),
      ));
      return;
    }

    final hours = double.tryParse(hoursController.text);
    setState(() {
      overtimeResult = hours != null ? hours * 1.5 : 0;
    });
  }
}
