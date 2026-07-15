import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _display = '0';
  
  void _onPressed(String text) {
    setState(() {
      if (_display == '0') _display = text;
      else _display += text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(child: Container(alignment: Alignment.bottomRight, padding: const EdgeInsets.all(24), child: Text(_display, style: const TextStyle(fontSize: 48)))),
          Row(children: ['7','8','9','/'].map((t) => Expanded(child: TextButton(onPressed: () => _onPressed(t), child: Text(t)))).toList()),
          Row(children: ['4','5','6','*'].map((t) => Expanded(child: TextButton(onPressed: () => _onPressed(t), child: Text(t)))).toList()),
          Row(children: ['1','2','3','-'].map((t) => Expanded(child: TextButton(onPressed: () => _onPressed(t), child: Text(t)))).toList()),
          Row(children: ['C','0','=','+'].map((t) => Expanded(child: TextButton(onPressed: () => _onPressed(t), child: Text(t)))).toList()),
        ],
      ),
    );
  }
}