import 'package:flutter/material.dart';
import 'screens/pantalla_principal.dart';

void main() {
  runApp(GastosApp());
}

class GastosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Gastos Personales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaPrincipal(),
    );
  }
}