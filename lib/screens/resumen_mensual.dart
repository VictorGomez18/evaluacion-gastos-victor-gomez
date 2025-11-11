import 'package:flutter/material.dart';
import '../models/modelo_gasto.dart';

class ResumenMensual extends StatefulWidget {
  final List<Gasto> gastos;

  const ResumenMensual({super.key, required this.gastos});

  @override
  State<ResumenMensual> createState() => _ResumenMensualState();
}

class _ResumenMensualState extends State<ResumenMensual> {
  DateTime _mesSeleccionado = DateTime.now();
  Map<String, double> _totalesPorCategoria = {};
  double _totalMensual = 0.0;

  final List<String> meses = const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  @override
  void initState() {
    super.initState();
    _calcularTotales();
  }

  void _calcularTotales() {
    final Map<String, double> totales = {};
    double total = 0;

    for (var gasto in widget.gastos) {
      if (gasto.fecha.year == _mesSeleccionado.year && 
          gasto.fecha.month == _mesSeleccionado.month) {
        totales.update(
          gasto.categoria,
          (value) => value + gasto.monto,
          ifAbsent: () => gasto.monto,
        );
        total += gasto.monto;
      }
    }

    setState(() {
      _totalesPorCategoria = totales;
      _totalMensual = total;
    });
  }

  void _cambiarMes(int direccion) {
    setState(() {
      _mesSeleccionado = DateTime(_mesSeleccionado.year, _mesSeleccionado.month + direccion);
      _calcularTotales();
    });
  }

  Color _getColorCategoria(String categoria) {
    switch (categoria) {
      case 'Comida':
        return const Color(0xFFFF6B6B);
      case 'Transporte':
        return const Color(0xFF4ECDC4);
      case 'Entretenimiento':
        return const Color(0xFF45B7D1);
      case 'Salud':
        return const Color(0xFF96CEB4);
      case 'Educación':
        return const Color(0xFFFFD166);
      case 'Hogar':
        return const Color(0xFFA882DD);
      default:
        return const Color(0xFF06D6A0);
    }
  }

  IconData _getIconoCategoria(String categoria) {
    switch (categoria) {
      case 'Comida':
        return Icons.restaurant;
      case 'Transporte':
        return Icons.directions_car;
      case 'Entretenimiento':
        return Icons.movie;
      case 'Salud':
        return Icons.local_hospital;
      case 'Educación':
        return Icons.school;
      case 'Hogar':
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categorias = _totalesPorCategoria.keys.toList();
    final nombreMes = meses[_mesSeleccionado.month - 1];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Resumen Mensual',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4361EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
                      onPressed: _mesSeleccionado.month > 1 ? () => _cambiarMes(-1) : null,
                    ),
                    Column(
                      children: [
                        Text(
                          '$nombreMes ${_mesSeleccionado.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${_totalMensual.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onPressed: _mesSeleccionado.month < DateTime.now().month ? 
                          () => _cambiarMes(1) : null,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: categorias.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay gastos en $nombreMes',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categorias.length,
                    itemBuilder: (ctx, index) {
                      final categoria = categorias[index];
                      final total = _totalesPorCategoria[categoria]!;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: _getColorCategoria(categoria).withAlpha(51),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _getIconoCategoria(categoria),
                              color: _getColorCategoria(categoria),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            categoria,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getColorCategoria(categoria),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}