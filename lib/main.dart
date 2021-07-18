import 'dart:convert';
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
    return Container();
  }
}

//Função que retorna o arquivo/lista que será utilizado pra salvar
Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File("${directoy.path}/data.json");
}

// Função para salvar dentro do arquivo/lista
Future<File> _saveData() async {
  String data = json.encode(_toDoList);
  final file = await _getFile();
  return file.writeAsString(data);
}
