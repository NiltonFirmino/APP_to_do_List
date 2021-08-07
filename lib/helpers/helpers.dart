import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
 

class Jhelp {

  final tarefaController = TextEditingController();

  List listadetarefa = [];

  void adicionar() {
     Map<String, dynamic> novatarefa = Map();
      novatarefa["title"] = tarefaController.text;
      tarefaController.text = "";
      novatarefa["ok"] = false;
      listadetarefa.add(novatarefa);
      saveData();
  }

  void organizar(){
      listadetarefa.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      saveData();
  }

  void recuperar(dataBD){
    listadetarefa = json.decode(dataBD!);
  }


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