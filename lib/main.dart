import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

bool matchOnList({dynamic value, required List<dynamic> list}) {
  bool result = false;
  for (var element in list) {
    if (result != true && element == value) {
      result = true;
    }
  }
  return result;
}

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Simple Calculator on Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _operation = '';
  String _result = '';

  final Color _orangeColorButton = Colors.orange;
  final Color _blackColorButton = Color.fromARGB(252, 45, 45, 45);
  final Color _grayColorButton = Colors.grey;

  final _buttonsTags = [
    '(',
    ')',
    'del',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'AC',
    '='
  ];

  List<ButtonCalculator> _generateButtons() {
    List<ButtonCalculator> _buttonsList = [];
    for (var buttonTag in _buttonsTags) {
      Color currentColor = _blackColorButton;
      if (matchOnList(value: buttonTag, list: ['(', ')', 'del', '.', 'AC'])) {
        currentColor = _grayColorButton;
      }
      if (matchOnList(value: buttonTag, list: ['/', 'x', '-', '+', '='])) {
        currentColor = _orangeColorButton;
      }
      _buttonsList.add(
        ButtonCalculator(
          color: currentColor,
          textData: buttonTag,
          function: _pushToken,
        ),
      );
    }
    return _buttonsList;
  }

  void _pushToken(String newToken) {
    setState(() {
      if (newToken == '=') {
        if (_operation == '') {
          _result = '';
          return;
        }
        Parser p = Parser();
        Expression exp = p.parse(_operation);
        ContextModel cm = ContextModel();
        String result = exp.evaluate(EvaluationType.REAL, cm).toString();
        _result = result;
        _operation = _result;
      } else if (newToken == 'del') {
        // ignore: prefer_is_empty
        _operation.length < 0
            ? _operation = _operation.substring(0, _operation.length - 1)
            : _operation = '';
      } else if (newToken == 'AC') {
        _operation = '';
        _result = '';
      } else if (newToken == 'x') {
        _operation += '*';
      } else {
        _operation += newToken;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Calculadora en Flutter',
            style: TextStyle(
              fontSize: 35.0,
            ),
          ),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.height / 2,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _operation,
                    style: const TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                ),
                const Divider(color: Colors.white),
                Container(
                  alignment: Alignment.centerRight,
                  height: MediaQuery.of(context).size.height / 10,
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _result,
                    style: const TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                ),
                const Divider(color: Colors.white),
                Expanded(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(16),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 4,
                    semanticChildCount: 4,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: _generateButtons(),
                  ),
                ),
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class ButtonCalculator extends StatelessWidget {
  const ButtonCalculator({
    super.key,
    required this.color,
    required this.textData,
    required this.function,
  });

  final Color color;
  final String textData;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          function(textData);
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(), //<-- SEE HERE
          backgroundColor: color,
        ),
        child: Text(
          textData,
          style: const TextStyle(
            fontSize: 50.0,
          ),
        ));
  }
}
