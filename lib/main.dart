import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _tarefaController = TextEditingController();

  // lista para armazenar as tarefas
  List _listadetarefa = [];

  @override
  void initState() {
    super.initState();

    _lerDataBD().then((dataBD) {
      setState(() {
        _listadetarefa = json.decode(dataBD!);
      });
    });
  }

  void _addtarefa() {
    setState(() {
      Map<String, dynamic> novatarefa = Map();
      novatarefa["title"] = _tarefaController.text;
      _tarefaController.text = "";
      novatarefa["ok"] = false;
      _listadetarefa.add(novatarefa);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            //EdgeInsets.fromLTRB(esquerda, cima, direita, baixo)
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _tarefaController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent, // background
                    onPrimary: Colors.white, // cor do texto
                  ),
                  onPressed: _addtarefa,
                  child: Text("ADD"),
                )
              ],
            ),
          ),

          //Corpo onde sera exibido as tarefas
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.only(top: 10.0),
            itemCount: _listadetarefa.length,
            itemBuilder : construcaoItens,
            )
          )
        ],
      ),
    );
  }

  Widget construcaoItens (context, index) {
    return CheckboxListTile(
      title: Text(_listadetarefa[index]["title"]),
      value: _listadetarefa[index]["ok"],
      secondary: CircleAvatar(
      child: Icon(
        _listadetarefa[index]["ok"] ? Icons.check : Icons.error
        ),
      ),
      onChanged: (c) {
        setState(() {
          _listadetarefa[index]["ok"] = c;
          _saveData();
        });
      },
    );         
  }


  //Função que retorna o arquivo/lista que será utilizado pra salvar
  Future<File> _getFile() async {
    final directoy = await getApplicationDocumentsDirectory();
    return File("${directoy.path}/data.json");
  }

  // Função para salvar dentro do arquivo/lista
  Future<File> _saveData() async {
    String dataBD = json.encode(_listadetarefa);
    final file = await _getFile();
    return file.writeAsString(dataBD);
  }

  // Função para obter os dados do arquivo/lista
  Future<String?> _lerDataBD() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
