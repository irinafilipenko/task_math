import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Processing'),
        ),
        body: DataProcessingWidget(),
      ),
    );
  }
}

class DataProcessingWidget extends StatefulWidget {
  @override
  _DataProcessingWidgetState createState() => _DataProcessingWidgetState();
}

class _DataProcessingWidgetState extends State<DataProcessingWidget> {
  String _result = '';

  @override
  void initState() {
    super.initState();
    _processData();
  }

  Future<void> _processData() async {
    try {
      // Завантаження даних з файлу
      final contents = await rootBundle.loadString('assets/data.txt');
      final data = contents
          .split('\n')
          .where((s) => s.trim().isNotEmpty) // Видаляємо порожні рядки
          .map(int.parse)
          .toList();

      // Максимальне та мінімальне значення
      final maxValue = data.reduce(max);
      final minValue = data.reduce(min);

      // Середнє арифметичне значення
      final meanValue = data.reduce((a, b) => a + b) / data.length;

      // Медіана
      final sortedData = List<int>.from(data)..sort();
      final middle = sortedData.length ~/ 2;
      final medianValue = sortedData.length.isEven
          ? (sortedData[middle - 1] + sortedData[middle]) / 2
          : sortedData[middle];

      setState(() {
        _result = 'Максимальне число в файлі: $maxValue\n'
            'Мінімальне число в файлі: $minValue\n'
            'Середнє арифметичне значення: $meanValue\n'
            'Медіана: $medianValue\n';
      });
    } catch (e) {
      setState(() {
        _result = 'Сталася помилка при обробці даних: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_result),
      ),
    );
  }
}
