import 'dart:convert';
import 'dart:core';
import 'package:projeto_c/helpers/helpers.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Jhelp mdata = Jhelp();

  //busca previa para inicialização do app com antiga lista salva
  @override
  void initState() {
    super.initState();
    mdata.lerDataBD().then((dataBD) {
      setState(() {
        mdata.listadetarefa = json.decode(dataBD!);
      });
    });
  }

  //Função que recarrega e organiza a lista
  Future<Null> _recarregar() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      mdata.organizar();
    });
    return null;
  }
  
  // adicionar tarefa
  void _addtarefa() {
    setState(() {
      mdata.adicionar();
      _recarregar();
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
                    controller: mdata.tarefaController,
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
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: mdata.listadetarefa.length,
              itemBuilder: construcaoItens,
            ),
          )
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
        title: Text(
          mdata.listadetarefa[index]["title"],
          style: TextStyle(
            decoration: (mdata.listadetarefa[index]["ok"]
                ? TextDecoration.lineThrough
                : TextDecoration.none),
            color: (mdata.listadetarefa[index]["ok"]
                ? Colors.blueGrey
                : Colors.black),
          ),
        ),
        value: mdata.listadetarefa[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(
              mdata.listadetarefa[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            mdata.listadetarefa[index]["ok"] = c;
            mdata.saveData();
            _recarregar();
          });
        },
      ),
      onDismissed: (direction) {
        Map<String, dynamic> _ultimoExcluido;
        int _ultimoExcluidoPosicao;
        setState(() {
          _ultimoExcluido = Map.from(mdata.listadetarefa[index]);
          _ultimoExcluidoPosicao = index;
          mdata.listadetarefa.removeAt(index);

          mdata.saveData();
          _recarregar();

          final excluirdesfazer = SnackBar(
            content:
                Text("Tarefa: \"${_ultimoExcluido["title"]}\" foi removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  mdata.listadetarefa
                      .insert(_ultimoExcluidoPosicao, _ultimoExcluido);
                  mdata.saveData();
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
}
