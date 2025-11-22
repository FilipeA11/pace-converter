import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class SwimmingScreen extends StatefulWidget {
  const SwimmingScreen({super.key});

  @override
  State<SwimmingScreen> createState() => _SwimmingScreenState();
}

class _SwimmingScreenState extends State<SwimmingScreen> {
  final TextEditingController _inputController = TextEditingController();
  SwimUnit _inputUnit = SwimUnit.minPer100m;
  SwimUnit _outputUnit = SwimUnit.kmh;
  String _result = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  double? _convertToMetersPerSecond(String input, SwimUnit unit) {
    try {
      if (unit == SwimUnit.minPer100m ||
          unit == SwimUnit.minPer50m ||
          unit == SwimUnit.minPer25m ||
          unit == SwimUnit.minPer100yd ||
          unit == SwimUnit.minPer50yd ||
          unit == SwimUnit.minPer25yd) {
        final parts = input.split(':');
        if (parts.length != 2) return null;

        final minutes = int.tryParse(parts[0]);
        final seconds = int.tryParse(parts[1]);

        if (minutes == null || seconds == null || seconds >= 60) return null;

        final totalSeconds = minutes * 60 + seconds;
        if (totalSeconds == 0) return null;

        switch (unit) {
          case SwimUnit.minPer100m:
            return 100 / totalSeconds;
          case SwimUnit.minPer50m:
            return 50 / totalSeconds;
          case SwimUnit.minPer25m:
            return 25 / totalSeconds;
          case SwimUnit.minPer100yd:
            return 91.44 / totalSeconds;
          case SwimUnit.minPer50yd:
            return 45.72 / totalSeconds;
          case SwimUnit.minPer25yd:
            return 22.86 / totalSeconds;
          default:
            return null;
        }
      } else if (unit == SwimUnit.secPer100m ||
          unit == SwimUnit.secPer50m ||
          unit == SwimUnit.secPer25m ||
          unit == SwimUnit.secPer100yd ||
          unit == SwimUnit.secPer50yd ||
          unit == SwimUnit.secPer25yd) {
        final value = double.tryParse(input.replaceAll(',', '.'));
        if (value == null || value <= 0) return null;

        switch (unit) {
          case SwimUnit.secPer100m:
            return 100 / value;
          case SwimUnit.secPer50m:
            return 50 / value;
          case SwimUnit.secPer25m:
            return 25 / value;
          case SwimUnit.secPer100yd:
            return 91.44 / value;
          case SwimUnit.secPer50yd:
            return 45.72 / value;
          case SwimUnit.secPer25yd:
            return 22.86 / value;
          default:
            return null;
        }
      } else {
        final value = double.tryParse(input.replaceAll(',', '.'));
        if (value == null || value <= 0) return null;

        switch (unit) {
          case SwimUnit.kmh:
            return value / 3.6;
          case SwimUnit.ms:
            return value;
          case SwimUnit.mph:
            return value * 0.44704;
          case SwimUnit.yds:
            return value * 0.9144;
          default:
            return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  String _convertFromMetersPerSecond(double ms, SwimUnit unit) {
    switch (unit) {
      case SwimUnit.minPer100m:
        final secondsPer100m = 100 / ms;
        final minutes = (secondsPer100m / 60).floor();
        final seconds = (secondsPer100m % 60).round();
        return '`${minutes.toString().padLeft(2, '0')}:`${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer50m:
        final secondsPer50m = 50 / ms;
        final minutes = (secondsPer50m / 60).floor();
        final seconds = (secondsPer50m % 60).round();
        return '`${minutes.toString().padLeft(2, '0')}:`${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer25m:
        final secondsPer25m = 25 / ms;
        final minutes = (secondsPer25m / 60).floor();
        final seconds = (secondsPer25m % 60).round();
        return '`${minutes.toString().padLeft(2, '0')}:`${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.secPer100m:
        return (100 / ms).toStringAsFixed(2);

      case SwimUnit.secPer50m:
        return (50 / ms).toStringAsFixed(2);

      case SwimUnit.secPer25m:
        return (25 / ms).toStringAsFixed(2);

      case SwimUnit.minPer100yd:
        final secondsPer100yd = 91.44 / ms;
        final minutes = (secondsPer100yd / 60).floor();
        final seconds = (secondsPer100yd % 60).round();
        return '`${minutes.toString().padLeft(2, '0')}:`${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer50yd:
        final secondsPer50yd = 45.72 / ms;
        final minutes = (secondsPer50yd / 60).floor();
        final seconds = (secondsPer50yd % 60).round();
        return '`${minutes.toString().padLeft(2, '0')}:`${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer25yd:
        final secondsPer25yd = 22.86 / ms;
        final minutes = (secondsPer25yd / 60).floor();
        final seconds = (secondsPer25yd % 60).round();
        return '`${minutes.toString().padLeft(2, '0')}:`${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.secPer100yd:
        return (91.44 / ms).toStringAsFixed(2);

      case SwimUnit.secPer50yd:
        return (45.72 / ms).toStringAsFixed(2);

      case SwimUnit.secPer25yd:
        return (22.86 / ms).toStringAsFixed(2);

      case SwimUnit.kmh:
        return (ms * 3.6).toStringAsFixed(2);

      case SwimUnit.ms:
        return ms.toStringAsFixed(2);

      case SwimUnit.mph:
        return (ms / 0.44704).toStringAsFixed(2);

      case SwimUnit.yds:
        return (ms / 0.9144).toStringAsFixed(2);
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

  String _getHintText(SwimUnit unit) {
    if (unit == SwimUnit.minPer100m ||
        unit == SwimUnit.minPer50m ||
        unit == SwimUnit.minPer25m ||
        unit == SwimUnit.minPer100yd ||
        unit == SwimUnit.minPer50yd ||
        unit == SwimUnit.minPer25yd) {
      return '__:__';
    }
    return '__,__';
  }

  Widget _buildUnitSelector({
    required String label,
    required SwimUnit value,
    required Function(SwimUnit?) onChanged,
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
            border: Border.all(color: Colors.cyan.shade200),
          ),
          child: DropdownButton<SwimUnit>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: SwimUnit.values.map((unit) {
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
        title: const Text('Conversor - Natação'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.cyan.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                          Icon(Icons.input, color: Colors.cyan.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Entrada',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan.shade700,
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
                          if (_inputUnit == SwimUnit.minPer100m ||
                              _inputUnit == SwimUnit.minPer50m ||
                              _inputUnit == SwimUnit.minPer25m ||
                              _inputUnit == SwimUnit.minPer100yd ||
                              _inputUnit == SwimUnit.minPer50yd ||
                              _inputUnit == SwimUnit.minPer25yd)
                            PaceInputFormatter()
                          else
                            SpeedInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          hintText: _getHintText(_inputUnit),
                          prefixIcon: Icon(
                            Icons.pool,
                            color: Colors.cyan.shade700,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.cyan.shade700),
                          ),
                        ),
                        onChanged: (_) => _convert(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.swap_vert,
                    size: 32,
                    color: Colors.cyan.shade700,
                  ),
                ),
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
                                  : '`$_result `${_outputUnit.suffix}',
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
                        ' Para pace (min/100m, min/50m, min/25m, etc): use o formato __:__ (ex: 01:30)\n'
                        ' Para velocidades e segundos: use o formato __,__ (ex: 90,50)\n'
                        ' Digite apenas números, os separadores aparecem automaticamente\n'
                        ' Conversões: 100yd = 91,44m | 50yd = 45,72m | 25yd = 22,86m',
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
