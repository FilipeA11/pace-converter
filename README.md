# Pace Converter 🏃‍♂️🏊‍♂️

Aplicativo Flutter completo para auxiliar corredores e nadadores no cálculo de pace, velocidade e análise de treinos.

## 📱 Funcionalidades

### 🏃 Corrida
- **Conversor de Unidades**
  - Converta entre 6 unidades diferentes: Pace/km, Pace/mi, km/h, m/s, mph, mi/s
  - Máscaras de entrada automáticas (`:` para pace, `,` para velocidades)
  - Conversão em tempo real

- **Status de Treino**
  - Calcule gasto calórico baseado em MET
  - Pace médio (min/km)
  - Velocidade média (km/h)
  - Entrada de tempo, distância, peso e altura

### 🏊 Natação
- **Conversor de Unidades**
  - Converta entre 16 unidades diferentes
  - Suporte para distâncias de 25m, 50m, 100m (metros e jardas)
  - Velocidades em km/h, m/s, mph, yd/s
  - Máscaras de entrada automáticas

- **Status de Treino**
  - Calcule gasto calórico baseado em MET
  - Pace para 50m e 100m
  - Velocidade média (m/s)
  - Entrada de tempo, distância, peso e altura

## 🎨 Interface

- Material Design 3
- Navegação hierárquica intuitiva
- Gradientes temáticos (laranja para corrida, ciano para natação)
- Cards informativos com dicas de uso
- Feedback visual em tempo real

## 🏗️ Arquitetura

```
lib/
├── main.dart                          # Ponto de entrada
├── screens/
│   ├── menu_app.dart                  # Menu principal
│   ├── menu_run.dart                  # Submenu corrida
│   ├── menu_swim.dart                 # Submenu natação
│   ├── running_screen.dart            # Conversor de corrida
│   ├── running_status_screen.dart     # Status de treino - corrida
│   ├── swimming_screen.dart           # Conversor de natação
│   └── swimming_status_screen.dart    # Status de treino - natação
└── utils/
    └── formatters.dart                # Formatadores e enums
```

## 🔧 Tecnologias

- **Flutter SDK**: ^3.9.2
- **Dart**: ^3.0.0
- **Material Design 3**: Sim
- **Packages**: 
  - cupertino_icons: ^1.0.8
  - flutter_launcher_icons: ^0.13.1

## 📊 Cálculos

### Gasto Calórico
Baseado em MET (Metabolic Equivalent of Task):
- **Corrida**: 8-13.5 MET (varia com velocidade)
- **Natação**: 6-12 MET (varia com intensidade)
- Fórmula: `Calorias = MET × Peso(kg) × Tempo(h)`

### Conversões
Todas as conversões usam **metros por segundo (m/s)** como unidade base para máxima precisão.

## 🚀 Como Usar

### Instalação
```bash
# Clone o repositório
git clone https://github.com/FilipeA11/pace-converter.git

# Entre no diretório
cd pace-converter

# Instale as dependências
flutter pub get

# Execute o aplicativo
flutter run
```

### Requisitos
- Flutter SDK 3.9.2 ou superior
- Dart 3.0.0 ou superior
- Android Studio / VS Code com extensões Flutter
- Dispositivo Android/iOS ou emulador

## 📝 Formato de Entrada

- **Tempo**: MM:SS (ex: 25:30)
- **Pace**: __:__ (ex: 05:30)
- **Velocidades**: __,__ (ex: 12,50)
- **Distância (corrida)**: km (ex: 5,0)
- **Distância (natação)**: metros (ex: 1000)
- **Peso**: kg (ex: 70,5)
- **Altura**: cm (ex: 175)

## 🎯 Unidades Suportadas

### Corrida (6 unidades)
- Pace/km (min/km)
- Pace/mi (min/mi)
- km/h
- m/s
- mph
- mi/s

### Natação (16 unidades)
- min/100m, min/50m, min/25m
- s/100m, s/50m, s/25m
- min/100yd, min/50yd, min/25yd
- s/100yd, s/50yd, s/25yd
- km/h, m/s, mph, yd/s

## 📄 Licença

Este projeto é de código aberto e está disponível sob a licença MIT.

## 👨‍💻 Desenvolvedor

**Filipe A11**
- GitHub: [@FilipeA11](https://github.com/FilipeA11)
- Repositório: [pace-converter](https://github.com/FilipeA11/pace-converter)

---

Desenvolvido com ❤️ usando Flutter
