import 'package:flutter/material.dart';

class MediaCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Média',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MediaCalculatorPage(),
    );
  }
}

class MediaCalculatorPage extends StatefulWidget {
  @override
  _MediaCalculatorPageState createState() => _MediaCalculatorPageState();
}

class _MediaCalculatorPageState extends State<MediaCalculatorPage> {
  TextEditingController _notaProva1Controller = TextEditingController();
  TextEditingController _notaProva2Controller = TextEditingController();
  TextEditingController _notaProva3Controller = TextEditingController();
  String _avisoMedia = '';
  Color _avisoMediaColor = Colors.transparent;
  bool _campoNota3Habilitado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Média'),
      ),
      body: SingleChildScrollView(
        // Adicionado SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Informe as notas das provas:',
                style: TextStyle(fontSize: 20, height: 3),
              ),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _notaProva1Controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nota Prova 1',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _notaProva2Controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nota Prova 2',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularMedia,
                child: Text('Calcular Média'),
              ),
              SizedBox(height: 20),
              Text(
                _avisoMedia,
                style: TextStyle(
                  color: _avisoMediaColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextField(
                  controller: _notaProva3Controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nota Prova 3:',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  enabled: _campoNota3Habilitado,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_campoNota3Habilitado) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Aviso'),
                          content: Text(
                            'Você não pode adicionar nota na P3, se ja estiver aprovado ou tiver zerado algumas das provas anteriores.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    double notaProva2 =
                        double.tryParse(_notaProva2Controller.text) ?? 0;
                    double notaProva1 =
                        double.tryParse(_notaProva1Controller.text) ?? 0;
                    _verificarp3(notaProva2, notaProva1);
                  }
                },
                child: Text('Calcular Média com P3'),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                // Botão para limpar os campos
                onPressed: _limparCampos,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Definindo a cor vermelha para o botão
                ),
                child: Text('Calcular novamente'),
              ),
              Align(
                alignment: Alignment
                    .bottomCenter, // Posicionando no canto inferior da tela
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    '*Para calcular a nota P3, adicione as notas da P1 e P2*',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcularMedia() {
    double notaProva1 = double.tryParse(_notaProva1Controller.text) ?? 0;
    double notaProva2 = double.tryParse(_notaProva2Controller.text) ?? 0;
    if (notaProva1 == 0 || notaProva2 == 0) {
      _campoNota3Habilitado = false;
    }
    double mediaAtual = (notaProva1 * 0.4) + (notaProva2 * 0.6);

    setState(() {
      if (mediaAtual >= 4.96) {
        _avisoMedia = 'Você está aprovado!';
        _avisoMediaColor = Colors.green;
      } else {
        if (notaProva2 == 0) {
          double notaProva2Necessaria = (((notaProva1 * 0.4) - 5) / 0.6);
          _avisoMedia =
              'Você precisa tirar ${notaProva2Necessaria.abs().toStringAsFixed(2)} na Prova 2 para ser aprovado.';
          _avisoMediaColor = Colors.orange;
        } else {
          double notanecessariaP3 = (((notaProva2 * 0.6) - 5) / 0.4);
          double notanecessariaProva3_2 = (((notaProva1 * 0.4) - 5) / 0.6);

          if (notanecessariaP3 >= notanecessariaProva3_2) {
            mediaAtual = notanecessariaP3;
          } else {
            mediaAtual = notanecessariaProva3_2;
          }
          if (mediaAtual >= 4.96) {
            _avisoMedia = 'Você está aprovado!';
            _avisoMediaColor = Colors.green;
          } else {
            _avisoMedia =
                'Você precisa tirar ${mediaAtual.abs().toStringAsFixed(2)} na Prova 3 para ser aprovado.';
            _avisoMediaColor = Colors.orange;
            setState(() {
              _campoNota3Habilitado = notaProva1 > 0 && notaProva2 > 0;
            });
          }
        }
      }
    });
  }

  void _verificarp3(double notaProva2, double notaProva1) {
    double notaProva3 = double.tryParse(_notaProva3Controller.text) ?? 0;
    double mediaComP3 = (notaProva3 * 0.4) + (notaProva2 * 0.6);
    double mediaComP3_2 = (notaProva1 * 0.4) + (notaProva3 * 0.6);

    setState(() {
      if (mediaComP3 >= 4.96) {
        _avisoMedia = 'Você está aprovado!';
        _avisoMediaColor = Colors.green;
      } else if (mediaComP3_2 >= 4.96) {
        _avisoMedia = 'Você está aprovado!';
        _avisoMediaColor = Colors.green;
      } else {
        _avisoMedia = 'Você não conseguiu nota suficiente para a Aprovação.';
        _avisoMediaColor = Colors.red;
      }
    });
  }

  void _limparCampos() {
    setState(() {
      _notaProva1Controller.clear();
      _notaProva2Controller.clear();
      _notaProva3Controller.clear();
      _avisoMedia = '';
      _avisoMediaColor = Colors.transparent;
      _campoNota3Habilitado = false;
    });
  }
}
