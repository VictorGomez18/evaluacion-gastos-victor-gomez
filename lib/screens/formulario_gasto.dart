import 'package:flutter/material.dart';
import '../models/modelo_gasto.dart';

class FormularioGasto extends StatefulWidget {
  final Gasto? gastoExistente;
  final Function(Gasto) onGuardarGasto;

  const FormularioGasto({
    super.key,
    required this.onGuardarGasto,
    this.gastoExistente,
  });

  @override
  FormularioGastoState createState() => FormularioGastoState();
}

class FormularioGastoState extends State<FormularioGasto> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  String _categoriaSeleccionada = 'Comida';
  DateTime _fechaSeleccionada = DateTime.now();

  final List<String> categorias = [
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
    if (widget.gastoExistente != null) {
      _descripcionController.text = widget.gastoExistente!.descripcion;
      _montoController.text = widget.gastoExistente!.monto.toString();
      _categoriaSeleccionada = widget.gastoExistente!.categoria;
      _fechaSeleccionada = widget.gastoExistente!.fecha;
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  void _presentarDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((fecha) {
      if (fecha != null) {
        setState(() {
          _fechaSeleccionada = fecha;
        });
      }
    });
  }

  void _guardarGasto() {
    if (_formKey.currentState!.validate()) {
      final nuevoGasto = Gasto(
        id: widget.gastoExistente?.id ?? DateTime.now().toString(),
        descripcion: _descripcionController.text,
        monto: double.parse(_montoController.text),
        categoria: _categoriaSeleccionada,
        fecha: _fechaSeleccionada,
      );

      widget.onGuardarGasto(nuevoGasto);
      Navigator.of(context).pop();
    }
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.gastoExistente == null ? 'Nuevo Gasto' : 'Editar Gasto',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  hintText: 'Ej: Almuerzo en restaurante',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFF4361EE)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Monto',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _montoController,
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFF4361EE)),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Categoría',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _categoriaSeleccionada,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    items: categorias.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria,
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
                            const SizedBox(width: 12),
                            Text(categoria),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _categoriaSeleccionada = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Fecha',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _presentarDatePicker,
                      child: const Text(
                        'Cambiar',
                        style: TextStyle(color: Color(0xFF4361EE)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarGasto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4361EE),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}