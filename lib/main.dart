import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pace Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Pace Converter',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Escolha sua modalidade',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 60),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ModalityCard(
                        title: 'Corrida',
                        icon: Icons.directions_run,
                        color: Colors.orange,
                        description: 'Calcule pace, velocidade e distância',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RunningScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _ModalityCard(
                        title: 'Natação',
                        icon: Icons.pool,
                        color: Colors.cyan,
                        description: 'Calcule pace e tempos na piscina',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SwimmingScreen(),
                            ),
                          );
                        },
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

class _ModalityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final VoidCallback onTap;

  const _ModalityCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

// Enumeração para unidades de velocidade
enum SpeedUnit {
  paceKm('Pace/km', 'min/km'),
  paceMile('Pace/mi', 'min/mi'),
  kmh('km/h', 'km/h'),
  ms('m/s', 'm/s'),
  mph('mph', 'mph'),
  mps('mi/s', 'mi/s');

  final String label;
  final String suffix;
  const SpeedUnit(this.label, this.suffix);
}

// Formatador para pace (formato __:__)
class PaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove tudo que não é número
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita a 4 dígitos
    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    // Formata __:__
    String formatted = '';
    int cursorPosition = digits.length;

    if (digits.isEmpty) {
      formatted = '';
    } else if (digits.length == 1) {
      formatted = digits + '_:__';
      cursorPosition = 1;
    } else if (digits.length == 2) {
      formatted = digits + ':__';
      cursorPosition = 2;
    } else if (digits.length == 3) {
      formatted = digits.substring(0, 2) + ':' + digits.substring(2) + '_';
      cursorPosition = 4;
    } else {
      formatted = digits.substring(0, 2) + ':' + digits.substring(2, 4);
      cursorPosition = 5;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

// Formatador para velocidade (formato __,__)
class SpeedInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove tudo que não é número
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita a 4 dígitos
    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    // Formata __,__
    String formatted = '';
    int cursorPosition = digits.length;

    if (digits.isEmpty) {
      formatted = '';
    } else if (digits.length == 1) {
      formatted = digits + '_,__';
      cursorPosition = 1;
    } else if (digits.length == 2) {
      formatted = digits + ',__';
      cursorPosition = 2;
    } else if (digits.length == 3) {
      formatted = digits.substring(0, 2) + ',' + digits.substring(2) + '_';
      cursorPosition = 4;
    } else {
      formatted = digits.substring(0, 2) + ',' + digits.substring(2, 4);
      cursorPosition = 5;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

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
        title: const Text('Corrida'),
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

// Enumeração para unidades de natação
enum SwimUnit {
  minPer100m('min/100m', 'min/100m'),
  secPer100m('s/100m', 's/100m'),
  minPer50m('min/50m', 'min/50m'),
  secPer50m('s/50m', 's/50m'),
  minPer25m('min/25m', 'min/25m'),
  secPer25m('s/25m', 's/25m'),
  minPer100yd('min/100yd', 'min/100yd'),
  secPer100yd('s/100yd', 's/100yd'),
  minPer50yd('min/50yd', 'min/50yd'),
  secPer50yd('s/50yd', 's/50yd'),
  minPer25yd('min/25yd', 'min/25yd'),
  secPer25yd('s/25yd', 's/25yd'),
  kmh('km/h', 'km/h'),
  ms('m/s', 'm/s'),
  mph('mph', 'mph'),
  yds('yd/s', 'yd/s');

  final String label;
  final String suffix;
  const SwimUnit(this.label, this.suffix);
}

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

  // Converter tudo para m/s primeiro (unidade base)
  double? _convertToMetersPerSecond(String input, SwimUnit unit) {
    try {
      // Unidades com formato mm:ss
      if (unit == SwimUnit.minPer100m ||
          unit == SwimUnit.minPer50m ||
          unit == SwimUnit.minPer25m ||
          unit == SwimUnit.minPer100yd ||
          unit == SwimUnit.minPer50yd ||
          unit == SwimUnit.minPer25yd) {
        // Parse pace format (mm:ss)
        final parts = input.split(':');
        if (parts.length != 2) return null;

        final minutes = int.tryParse(parts[0]);
        final seconds = int.tryParse(parts[1]);

        if (minutes == null || seconds == null || seconds >= 60) return null;

        final totalSeconds = minutes * 60 + seconds;
        if (totalSeconds == 0) return null;

        // Converter pace para m/s
        switch (unit) {
          case SwimUnit.minPer100m:
            return 100 / totalSeconds;
          case SwimUnit.minPer50m:
            return 50 / totalSeconds;
          case SwimUnit.minPer25m:
            return 25 / totalSeconds;
          case SwimUnit.minPer100yd:
            return 91.44 / totalSeconds; // 100 jardas
          case SwimUnit.minPer50yd:
            return 45.72 / totalSeconds; // 50 jardas
          case SwimUnit.minPer25yd:
            return 22.86 / totalSeconds; // 25 jardas
          default:
            return null;
        }
      }
      // Unidades com segundos
      else if (unit == SwimUnit.secPer100m ||
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
      }
      // Outras velocidades
      else {
        final value = double.tryParse(input.replaceAll(',', '.'));
        if (value == null || value <= 0) return null;

        switch (unit) {
          case SwimUnit.kmh:
            return value / 3.6; // km/h para m/s
          case SwimUnit.ms:
            return value;
          case SwimUnit.mph:
            return value * 0.44704; // mph para m/s
          case SwimUnit.yds:
            return value * 0.9144; // jardas/s para m/s
          default:
            return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  // Converter de m/s para a unidade desejada
  String _convertFromMetersPerSecond(double ms, SwimUnit unit) {
    switch (unit) {
      case SwimUnit.minPer100m:
        final secondsPer100m = 100 / ms;
        final minutes = (secondsPer100m / 60).floor();
        final seconds = (secondsPer100m % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer50m:
        final secondsPer50m = 50 / ms;
        final minutes = (secondsPer50m / 60).floor();
        final seconds = (secondsPer50m % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer25m:
        final secondsPer25m = 25 / ms;
        final minutes = (secondsPer25m / 60).floor();
        final seconds = (secondsPer25m % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

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
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer50yd:
        final secondsPer50yd = 45.72 / ms;
        final minutes = (secondsPer50yd / 60).floor();
        final seconds = (secondsPer50yd % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      case SwimUnit.minPer25yd:
        final secondsPer25yd = 22.86 / ms;
        final minutes = (secondsPer25yd / 60).floor();
        final seconds = (secondsPer25yd % 60).round();
        return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

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
        title: const Text('Natação'),
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

              // Ícone de conversão
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
                        '• Para pace (min/100m, min/50m, min/25m, etc): use o formato __:__ (ex: 01:30)\n'
                        '• Para velocidades e segundos: use o formato __,__ (ex: 90,50)\n'
                        '• Digite apenas números, os separadores aparecem automaticamente\n'
                        '• Conversões: 100yd = 91,44m | 50yd = 45,72m | 25yd = 22,86m',
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
