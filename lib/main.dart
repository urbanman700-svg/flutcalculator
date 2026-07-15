import 'package:flutter/material.dart';import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';
  bool _isDarkTheme = false;
  List<String> _history = [];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _onButtonPressed(String button) async {
    if (button == 'C') {
      _expression = '';
      _result = '';
    } else if (button == '=' ) {
      try {
        _result = _calculate(_expression);
 _saveHistory(_expression + ' = ' + _result);
      } catch (e) {
        _result = 'Error';
      }
    } else {
      _expression += button;
    }
    setState(() {});
  }

  String _calculate(String expression) {
    expression = expression.replaceAll('÷', '/');
    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll(',', '');
    return (eval(expression)).toStringAsFixed(2);
  }

  Future<void> _saveHistory(String expression) async {
    final prefs = await _prefs;
    setState(() {
      _history.insert(0, expression);
    });
    prefs.setString('history', _history.join('|'));
  }

  Future<void> _loadHistory() async {
    final prefs = await _prefs;
    String history = prefs.getString('history') ?? '';
    setState(() {
      _history = history.split('|');
    });
  }

  Future<void> _clearHistory() async {
    final prefs = await _prefs;
    prefs.remove('history');
    setState(() {
      _history = [];
    });
  }

  void _toggleTheme() async {
    final prefs = await _prefs;
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
    prefs.setBool('isDarkTheme', _isDarkTheme);
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await _prefs;
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.wb_sunny : Icon. Iron),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  _expression,
                  style: TextStyle(
                    fontSize: 20,
                    color: _isDarkTheme ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: _isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  _buildButton('C'),
                  _buildButton('%'),
                  _buildButton('÷'),
                  _buildButton('×'),
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('-'),
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('+'),
                  _buildButton('.'),
                  _buildButton('0'),
                  _buildButton('⌫'),
                  _buildButton('='),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage(_history, _clearHistory)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String button) {
    return GestureDetector(
      onTap: () {
        _onButtonPressed(button);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: button == '=' || button == '÷' || button == '×' || button == '+' || button == '-' ? Colors.purple : _isDarkTheme ? Colors.grey[800] : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            button,
            style: TextStyle(
              fontSize: 24,
              color: button == '=' || button == '÷' || button == '×' || button == '+' || button == '-' ? Colors.white : _isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> _history;
  final Function _clearHistory;

  HistoryPage(this._history, this._clearHistory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _history.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_history[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _history.removeAt(index);
                  _clearHistory();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear_all),
        onPressed: _clearHistory,
      ),
    );
  }
}