import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
 

class Jhelp {

  final tarefaController = TextEditingController();

  List listadetarefa = [];

  //Função que retorna o arquivo/lista que será utilizado pra salvar
  Future<File> getFile() async {
    final directoy = await getApplicationDocumentsDirectory();
    return File("${directoy.path}/data.json");
  }

  // Função para salvar dentro do arquivo/lista
  Future<File> saveData() async {
    String dataBD = json.encode(listadetarefa);
    final file = await getFile();
    return file.writeAsString(dataBD);
  }

  // Função para obter os dados do arquivo/lista
  Future<String?> lerDataBD() async {
    try {
      final file = await getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}