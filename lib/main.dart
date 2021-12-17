import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double? _numberFrom;
  String? _startMeasure;
  String? _convertedMeasure;
  String? _resultMessage;

  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];

  final Map<String, int> _measuresMap = {
    'Metros': 0,
    'Kilometros': 1,
    'Gramos': 2,
    'Kilogramos': 3,
    'Pies': 4,
    'Millas': 5,
    'Libras (lbs)': 6,
    'Onzas': 7,
  };

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  @override
  void initState() {
    _numberFrom = 0;
    super.initState();
  }

  final TextStyle inputStyle = TextStyle(
    fontSize: 20,
    color: Colors.blue[900],
  );

  final TextStyle labelStyle = TextStyle(
    fontSize: 24,
    color: Colors.grey[700],
  );

  void convert(double value, String from, String to) {
    int? nFrom = _measuresMap[from];
    int? nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];
    double result = value * multiplier;
    if (result == 0) {
      _resultMessage = 'This conversion cannot be performed';
    } else {
      _resultMessage =
          '${_numberFrom.toString()} $_startMeasure are ${result.toString()} $_convertedMeasure';
    }
    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Convertidor de Medidas',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Convertidor de Medidas'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Spacer(),
                Text(
                  'Value',
                  style: labelStyle,
                ),
                const Spacer(),
                TextField(
                  style: inputStyle,
                  decoration: const InputDecoration(
                      hintText: "Por favor inserte la medida a convertir"),
                  onChanged: (text) {
                    var rv = double.tryParse(text);
                    if (rv != null) {
                      setState(
                        () {
                          _numberFrom = rv;
                        },
                      );
                    }
                  },
                ),
                const Spacer(),
                Text(
                  'De',
                  style: labelStyle,
                ),
                DropdownButton(
                  isExpanded: true,
                  style: inputStyle,
                  items: _measures.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _startMeasure = value;
                    });
                  },
                  value: _startMeasure,
                ),
                const Spacer(),
                Text(
                  'Para',
                  style: labelStyle,
                ),
                const Spacer(),
                DropdownButton(
                  isExpanded: true,
                  style: inputStyle,
                  items: _measures.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: inputStyle,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _convertedMeasure = value;
                    });
                  },
                  value: _convertedMeasure,
                ),
                const Spacer(
                  flex: 2,
                ),
                RaisedButton(
                  child: Text(
                    'Convertir',
                    style: inputStyle,
                  ),
                  onPressed: () {
                    if (_startMeasure!.isEmpty ||
                        _convertedMeasure!.isEmpty ||
                        _numberFrom == 0) {
                      return;
                    } else {
                      convert(_numberFrom!, _startMeasure!, _convertedMeasure!);
                    }
                  },
                ),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  (_resultMessage == null) ? '' : _resultMessage.toString(),
                  style: inputStyle,
                ),
                const Spacer(
                  flex: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
