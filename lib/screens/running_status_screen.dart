import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RunningStatusScreen extends StatefulWidget {
  const RunningStatusScreen({super.key});

  @override
  State<RunningStatusScreen> createState() => _RunningStatusScreenState();
}

class _RunningStatusScreenState extends State<RunningStatusScreen> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _calories = '';
  String _pace = '';
  String _avgSpeed = '';

  @override
  void dispose() {
    _timeController.dispose();
    _distanceController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculate() {
    try {
      // Pega os valores dos campos
      final timeParts = _timeController.text.split(':');
      if (timeParts.length != 2) {
        _showError('Tempo inválido');
        return;
      }

      final minutes = int.tryParse(timeParts[0]);
      final seconds = int.tryParse(timeParts[1]);
      if (minutes == null || seconds == null || seconds >= 60) {
        _showError('Tempo inválido');
        return;
      }

      final totalMinutes = minutes + seconds / 60;
      final totalHours = totalMinutes / 60;

      final distance = double.tryParse(
        _distanceController.text.replaceAll(',', '.'),
      );
      final weight = double.tryParse(
        _weightController.text.replaceAll(',', '.'),
      );
      final height = double.tryParse(
        _heightController.text.replaceAll(',', '.'),
      );

      if (distance == null || distance <= 0) {
        _showError('Distância inválida');
        return;
      }
      if (weight == null || weight <= 0) {
        _showError('Peso inválido');
        return;
      }
      if (height == null || height <= 0) {
        _showError('Altura inválida');
        return;
      }

      // Calcula velocidade média em km/h
      final avgSpeedKmh = distance / totalHours;

      // Calcula pace (min/km)
      final paceMinPerKm = totalMinutes / distance;
      final paceMin = paceMinPerKm.floor();
      final paceSec = ((paceMinPerKm - paceMin) * 60).round();

      // Calcula gasto calórico
      // Fórmula aproximada: MET * peso * tempo(h)
      // MET para corrida varia com velocidade
      double met;
      if (avgSpeedKmh < 8) {
        met = 8.0; // corrida leve
      } else if (avgSpeedKmh < 10) {
        met = 10.0; // corrida moderada
      } else if (avgSpeedKmh < 12) {
        met = 11.5; // corrida intensa
      } else {
        met = 13.5; // corrida muito intensa
      }

      final calories = met * weight * totalHours;

      setState(() {
        _avgSpeed = avgSpeedKmh.toStringAsFixed(2);
        _pace =
            '${paceMin.toString().padLeft(2, '0')}:${paceSec.toString().padLeft(2, '0')}';
        _calories = calories.toStringAsFixed(0);
      });
    } catch (e) {
      _showError('Erro ao calcular');
    }
  }

  void _showError(String message) {
    setState(() {
      _calories = message;
      _pace = '---';
      _avgSpeed = '---';
    });
  }

  Widget _buildInputCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    List<TextInputFormatter>? formatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange.shade700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange.shade700),
        ),
      ),
      onChanged: (_) => _calculate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status de Treino - Corrida'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(
                title: 'Dados do Treino',
                icon: Icons.input,
                children: [
                  _buildTextField(
                    controller: _timeController,
                    label: 'Tempo',
                    hint: '__:__',
                    icon: Icons.timer,
                    formatters: [_TimeInputFormatter()],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _distanceController,
                    label: 'Distância (km)',
                    hint: '0,00',
                    icon: Icons.straighten,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputCard(
                title: 'Dados Pessoais',
                icon: Icons.person,
                children: [
                  _buildTextField(
                    controller: _weightController,
                    label: 'Peso (kg)',
                    hint: '0,0',
                    icon: Icons.monitor_weight,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _heightController,
                    label: 'Altura (cm)',
                    hint: '0',
                    icon: Icons.height,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Resultados',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _ResultRow(
                        label: 'Gasto Calórico',
                        value: _calories.isEmpty ? '---' : '$_calories kcal',
                        icon: Icons.local_fire_department,
                      ),
                      const Divider(height: 24),
                      _ResultRow(
                        label: 'Pace Médio',
                        value: _pace.isEmpty ? '---' : '$_pace min/km',
                        icon: Icons.speed,
                      ),
                      const Divider(height: 24),
                      _ResultRow(
                        label: 'Velocidade Média',
                        value: _avgSpeed.isEmpty ? '---' : '$_avgSpeed km/h',
                        icon: Icons.directions_run,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informações',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Tempo: formato MM:SS (ex: 25:30)\n'
                        '• Distância: em quilômetros (ex: 5,0)\n'
                        '• Peso: em quilogramas (ex: 70,5)\n'
                        '• Altura: em centímetros (ex: 175)\n'
                        '• O cálculo calórico é uma estimativa baseada em MET',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.green.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    String formatted = '';
    int cursorPosition = 0;

    if (digitsOnly.length >= 1) {
      formatted = digitsOnly[0];
      cursorPosition = 1;
    }
    if (digitsOnly.length >= 2) {
      formatted += digitsOnly[1];
      cursorPosition = 2;
    }
    if (digitsOnly.length >= 3) {
      formatted += ':${digitsOnly[2]}';
      cursorPosition = 4;
    }
    if (digitsOnly.length >= 4) {
      formatted += digitsOnly[3];
      cursorPosition = 5;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
