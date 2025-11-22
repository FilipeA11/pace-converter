import 'package:flutter/services.dart';

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

// Enumeração para unidades de velocidade (corrida)
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
