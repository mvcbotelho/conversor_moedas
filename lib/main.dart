import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const req_api =
    'https://api.hgbrasil.com/finance/quotations?format=json&key=f6b7491b';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(req_api);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();

  double dolar;
  double euro;
  double libra;

  void _realChange(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
    libraController.text = (real/libra).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    libraController.text = (dolar * this.dolar / libra).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    libraController.text = (euro * this.euro / libra).toStringAsFixed(2);
  }

  void _libraChange(String text) {
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    dolarController.text = (libra * this.libra / dolar).toStringAsFixed(2);
    euroController.text = (libra * this.libra / euro).toStringAsFixed(2);
  }

  void _resetButton(){
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
    libraController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Conversor de moeda'),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh
            ),
            onPressed: _resetButton,
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando dados...',
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar dados',
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];

                print(dolar);
                print(euro);
                print(libra);

                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      buildTextFild("Reais", "R\$", realController, _realChange),
                      Divider(),
                      buildTextFild("Dolares", "U\$", dolarController, _dolarChange),
                      Divider(),
                      buildTextFild("Euros", "€", euroController, _euroChange),
                      Divider(),
                      buildTextFild("Libras", "£", libraController, _libraChange),
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

Widget buildTextFild(String currencie, String prefix, TextEditingController ctl, Function change) {
  return TextField(
    controller: ctl,
    decoration: InputDecoration(
        labelText: currencie,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: change,
    keyboardType: TextInputType.number,
  );
}
