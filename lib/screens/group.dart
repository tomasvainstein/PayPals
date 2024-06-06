import 'package:flutter/material.dart';
import 'package:flutter_app_gastos/main.dart';
import 'package:flutter_app_gastos/screens/add_expense.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_gastos/services/addExpensePageLogic.dart';

class GroupScreen extends StatelessWidget {
  final String groupId;
  final String groupName;

  GroupScreen({required this.groupId, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Provider.of<MyAppState>(context, listen: false).updateHomePage();
          },
        ),
        title: Text(groupName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.group,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  DebtTile(
                    debtor: 'Micaela',
                    amount: 699.32,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add your logic for settling debts here
                    },
                    child: Text('Ajustar cuentas'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<Gasto>>(
                          future: obtenerGastosDeGrupo(groupId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error al obtener los gastos del grupo: ${snapshot.error}');
                            } else {
                              List<Gasto> expenses = snapshot.data ?? [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Gastos:',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Column(
                                    children: expenses.map((expense) {
                                      DateTime date = expense.date.toDate();
                                      return ExpenseTile(
                                        month: date.month.toString(),
                                        day: date.day.toString(),
                                        title: expense.description,
                                        payer: expense.payer,
                                        amount: expense.amount,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen(groupId: groupId)),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class DebtTile extends StatelessWidget {
  final String debtor;
  final double amount;

  DebtTile({
    required this.debtor,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '$debtor te debe \$${amount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final String month;
  final String day;
  final String title;
  final String payer;
  final double amount;

  ExpenseTile({
    required this.month,
    required this.day,
    required this.title,
    required this.payer,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              month,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1),
            Text(
              day,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$payer \$${amount.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
