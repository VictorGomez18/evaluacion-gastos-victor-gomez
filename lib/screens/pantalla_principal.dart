import 'package:flutter/material.dart';
import '../models/modelo_gasto.dart';
import 'formulario_gasto.dart';
import 'resumen_mensual.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  List<Gasto> gastos = [];
  String? categoriaFiltro;
  double totalMensual = 0.0;

  final List<String> categorias = const [
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Hogar',
    'Otros'
  ];

  @override
  void initState() {
    super.initState();
    _calcularTotalMensual();
  }

  void _calcularTotalMensual() {
    final now = DateTime.now();
    double total = 0;
    for (var gasto in gastos) {
      if (gasto.fecha.year == now.year && gasto.fecha.month == now.month) {
        total += gasto.monto;
      }
    }
    setState(() {
      totalMensual = total;
    });
  }

  void _agregarGasto(Gasto nuevoGasto) {
    setState(() {
      gastos.add(nuevoGasto);
      gastos.sort((a, b) => b.fecha.compareTo(a.fecha));
      _calcularTotalMensual();
    });
  }

  void _editarGasto(String id, Gasto gastoEditado) {
    setState(() {
      final index = gastos.indexWhere((gasto) => gasto.id == id);
      if (index != -1) {
        gastos[index] = gastoEditado;
        gastos.sort((a, b) => b.fecha.compareTo(a.fecha));
        _calcularTotalMensual();
      }
    });
  }

  void _eliminarGasto(String id) {
    setState(() {
      gastos.removeWhere((gasto) => gasto.id == id);
      _calcularTotalMensual();
    });
  }

  List<Gasto> _getGastosFiltrados() {
    if (categoriaFiltro == null) {
      return gastos;
    }
    return gastos.where((gasto) => gasto.categoria == categoriaFiltro).toList();
  }

  void _mostrarFormularioGasto([Gasto? gastoExistente]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FormularioGasto(
          gastoExistente: gastoExistente,
          onGuardarGasto: gastoExistente == null ? _agregarGasto : (gasto) => _editarGasto(gastoExistente.id, gasto),
        );
      },
    );
  }

  void _mostrarResumen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ResumenMensual(gastos: gastos),
      ),
    );
  }

  void _mostrarOpcionesGasto(Gasto gasto) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar Gasto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _mostrarFormularioGasto(gasto);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Eliminar Gasto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _mostrarDialogoEliminar(gasto);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarDialogoEliminar(Gasto gasto) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Eliminar Gasto'),
          content: Text('¿Estás seguro de que quieres eliminar el gasto "${gasto.descripcion}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarGasto(gasto.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Gasto eliminado'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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
    final gastosFiltrados = _getGastosFiltrados();
    final now = DateTime.now();
    final nombreMes = const [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ][now.month - 1];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Mis Gastos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4361EE),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4361EE), Color(0xFF3A0CA3)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.trending_up, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Total de $nombreMes',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${totalMensual.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: categoriaFiltro,
                        hint: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('Todas las categorías'),
                        ),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Todas las categorías'),
                            ),
                          ),
                          ...categorias.map((categoria) {
                            return DropdownMenuItem(
                              value: categoria,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getColorCategoria(categoria),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(categoria),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            categoriaFiltro = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Mis Gastos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      '${gastosFiltrados.length} gastos',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: gastosFiltrados.isEmpty
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
                            const Text(
                              'No hay gastos registrados',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Presiona el botón + para agregar uno',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: gastosFiltrados.length,
                        itemBuilder: (ctx, index) {
                          final gasto = gastosFiltrados[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: _getColorCategoria(gasto.categoria).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getIconoCategoria(gasto.categoria),
                                  color: _getColorCategoria(gasto.categoria),
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                gasto.descripcion,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              subtitle: Text(
                                '${gasto.fecha.day}/${gasto.fecha.month}/${gasto.fecha.year} • ${gasto.categoria}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                '\$${gasto.monto.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _getColorCategoria(gasto.categoria),
                                ),
                              ),
                              onTap: () => _mostrarOpcionesGasto(gasto),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _mostrarResumen,
              backgroundColor: const Color(0xFF7209B7),
              foregroundColor: Colors.white,
              elevation: 4,
              mini: true,
              child: const Icon(Icons.analytics, size: 24),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioGasto(),
        backgroundColor: const Color(0xFF4361EE),
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}