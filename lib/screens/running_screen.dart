import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  final TextEditingController _inputController = TextEditingController();
  SpeedUnit _inputUnit = SpeedUnit.paceKm;
  SpeedUnit _outputUnit = SpeedUnit.kmh;
  String _result = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  // Converter tudo para m/s primeiro (unidade base)
  double? _convertToMetersPerSecond(String input, SpeedUnit unit) {
    try {
      if (unit == SpeedUnit.paceKm || unit == SpeedUnit.paceMile) {
        // Parse pace format (mm:ss)
        final parts = input.split(':');
        if (parts.length != 2) return null;

        final minutes = int.tryParse(parts[0]);
        final seconds = int.tryParse(parts[1]);

        if (minutes == null || seconds == null || seconds >= 60) return null;

        final totalSeconds = minutes * 60 + seconds;
        if (totalSeconds == 0) return null;

        // Converter pace para m/s
        if (unit == SpeedUnit.paceKm) {
          return 1000 / totalSeconds; // m/s
        } else {
          return 1609.344 / totalSeconds; // milha em metros / segundos
        }
      } else {
        final value = double.tryParse(input.replaceAll(',', '.'));
        if (value == null || value <= 0) return null;

        switch (unit) {
          case SpeedUnit.kmh:
            return value / 3.6; // km/h para m/s
          case SpeedUnit.ms:
            return value;
          case SpeedUnit.mph:
            return value * 0.44704; // mph para m/s
          case SpeedUnit.mps:
            return value * 1609.344; // milhas/s para m/s
          default:
            return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  // Converter de m/s para a unidade desejada
  String _convertFromMetersPerSecond(double ms, SpeedUnit unit) {
    switch (unit) {
      case SpeedUnit.paceKm:
        final secondsPerKm = 1000 / ms;
        final minutes = (secondsPerKm / 60).floor();
        final seconds = (secondsPerKm % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      case SpeedUnit.paceMile:
        final secondsPerMile = 1609.344 / ms;
        final minutes = (secondsPerMile / 60).floor();
        final seconds = (secondsPerMile % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      case SpeedUnit.kmh:
        return (ms * 3.6).toStringAsFixed(2);

      case SpeedUnit.ms:
        return ms.toStringAsFixed(2);

      case SpeedUnit.mph:
        return (ms / 0.44704).toStringAsFixed(2);

      case SpeedUnit.mps:
        return (ms / 1609.344).toStringAsFixed(6);
    }
  }

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _result = '');
      return;
    }

    final ms = _convertToMetersPerSecond(input, _inputUnit);
    if (ms == null) {
      setState(() => _result = 'Valor inválido');
      return;
    }

    final converted = _convertFromMetersPerSecond(ms, _outputUnit);
    setState(() => _result = converted);
  }

  String _getHintText(SpeedUnit unit) {
    if (unit == SpeedUnit.paceKm || unit == SpeedUnit.paceMile) {
      return '__:__';
    }
    return '__,__';
  }

  Widget _buildUnitSelector({
    required String label,
    required SpeedUnit value,
    required Function(SpeedUnit?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: DropdownButton<SpeedUnit>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: SpeedUnit.values.map((unit) {
              return DropdownMenuItem(value: unit, child: Text(unit.label));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor - Corrida'),
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
              // Card de entrada
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
                          Icon(Icons.input, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Entrada',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildUnitSelector(
                        label: 'Unidade de entrada',
                        value: _inputUnit,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _inputUnit = value;
                              _inputController.clear();
                              _result = '';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _inputController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          if (_inputUnit == SpeedUnit.paceKm ||
                              _inputUnit == SpeedUnit.paceMile)
                            PaceInputFormatter()
                          else
                            SpeedInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          hintText: _getHintText(_inputUnit),
                          prefixIcon: Icon(
                            Icons.speed,
                            color: Colors.orange.shade700,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                        onChanged: (_) => _convert(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Ícone de conversão
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.swap_vert,
                    size: 32,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Card de saída
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
                          Icon(Icons.output, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Resultado',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildUnitSelector(
                        label: 'Unidade de saída',
                        value: _outputUnit,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _outputUnit = value;
                              _convert();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resultado',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result.isEmpty
                                  ? '---'
                                  : '$_result ${_outputUnit.suffix}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Informações adicionais
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
                            'Dicas',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Para pace: use o formato __:__ (ex: 05:30)\n'
                        '• Para velocidades: use o formato __,__ (ex: 10,50)\n'
                        '• Digite apenas números, os separadores aparecem automaticamente',
                        style: TextStyle(
                          fontSize: 13,
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
