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
  // lista para armazenar as tarefas
  List _toDoList = [];

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
            padding: EdgeInsets.fromLTRB(17.0,1.0, 7.0, 1.0), 
            child: Row(
              children: <Widget> [
                Expanded(child:  TextField(
                  decoration: InputDecoration(
                  labelText: "Nova Tarefa",
                  labelStyle: 
                    TextStyle(color: Colors.deepPurple),

                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent, // background
                  onPrimary: Colors.white, // cor do texto
                  ),
                  onPressed: () { },
                  child: Text('ADD'),
                )
              ],
            ),
        )
        ],
      ),
    );
  }

  //Função que retorna o arquivo/lista que será utilizado pra salvar
  Future<File> _getFile() async {
    final directoy = await getApplicationDocumentsDirectory();
    return File("${directoy.path}/data.json");
  }

  // Função para salvar dentro do arquivo/lista
  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  // Função para obter os dados do arquivo/lista
  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
