import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const request = 'https://api.hgbrasil.com/finance?key=51cedc59';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _realCtrl = TextEditingController();
  final _euroCtrl = TextEditingController();
  final _dollarCtrl = TextEditingController();

  double _dollar;
  double _euro;

  void _clearAllFields() {
    _realCtrl.clear();
    _dollarCtrl.clear();
    _euroCtrl.clear();
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAllFields();
    } else {
      var real = double.parse(text);
      _dollarCtrl.text = (real / _dollar).toStringAsFixed(2);
      _euroCtrl.text = (real / _euro).toStringAsFixed(2);
    }
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAllFields();
    } else {
      var dollar = double.parse(text);
      _realCtrl.text = (dollar * _dollar).toStringAsFixed(2);
      _euroCtrl.text = (dollar * _dollar / _euro).toStringAsFixed(2);
    }
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAllFields();
    } else {
      var euro = double.parse(text);
      _realCtrl.text = (euro * _euro).toStringAsFixed(2);
      _dollarCtrl.text = (euro * _euro / _dollar).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Crypto Watch'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Loading',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Text(
                  'Error while loading data :(',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                );
              } else {
                _dollar = snapshot.data['results']['currencies']['USD']['buy'];
                _euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      _textFieldBuilder(label: 'Reais', prefix: 'R', controller: _realCtrl, onChanged: _realChanged),
                      Divider(),
                      _textFieldBuilder(label: 'Dollars', prefix: 'US', controller: _dollarCtrl, onChanged: _dollarChanged),
                      Divider(),
                      _textFieldBuilder(label: 'Euros', prefix: '€', controller: _euroCtrl, onChanged: _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

TextField _textFieldBuilder({String label, String prefix, TextEditingController controller, Function onChanged}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
      ),
      border: OutlineInputBorder(),
      prefixText: '$prefix\$',
    ),
    style: TextStyle(
      color: Colors.white,
      fontSize: 25.0,
    ),
  );
}

Future<Map<String, dynamic>> getData() async {
  try {
    final response = await Dio().get(request);
    return response.data;
  } catch (e) {
    print(e);
  }
}
