import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _tarefaController = TextEditingController();

  // lista para armazenar as tarefas
  List _listadetarefa = [];

  //Desfazendo ultima exclusão

  //busca previa para inicialização do app com antiga lista salva
  @override
  void initState() {
    super.initState();

    _lerDataBD().then((dataBD) {
      setState(() {
        _listadetarefa = json.decode(dataBD!);
      });
    });
  }

  // adicionar tarefa
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

  // estrutura Barra e Corpo
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //barra de app simples
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

          //Extensão do Corpo onde sera exibido as tarefas
          Expanded(
            child: RefreshIndicator(
              onRefresh: _recarregar,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _listadetarefa.length,
                itemBuilder: construcaoItens,
            ),
          ))
        ],
      ),
    );
  }

  // contrução de cada tarefa, setState e controle de exclusão
  Widget construcaoItens(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_listadetarefa[index]["title"],
          style: TextStyle(decoration:(_listadetarefa[index]["ok"] ? 
            TextDecoration.lineThrough : TextDecoration.none),
            color: (_listadetarefa[index]["ok"] ? 
            Colors.blueGrey : Colors.black ),
            ),
          
          ),
        value: _listadetarefa[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_listadetarefa[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            _listadetarefa[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        Map<String, dynamic> _ultimoExcluido;
        int _ultimoExcluidoPosicao;
        setState(() {
          _ultimoExcluido = Map.from(_listadetarefa[index]);
          _ultimoExcluidoPosicao = index;
          _listadetarefa.removeAt(index);

          _saveData();

          final excluirdesfazer = SnackBar(
            content:
                Text("Tarefa: \"${_ultimoExcluido["title"]}\" foi removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _listadetarefa.insert(
                      _ultimoExcluidoPosicao, _ultimoExcluido);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 4),
          );
          ScaffoldMessenger.of(context).showSnackBar(excluirdesfazer);
        });
      },
    );
  }


  //Função que recarrega e organiza a lista
  Future<Null> _recarregar() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _listadetarefa.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });
    return null;
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