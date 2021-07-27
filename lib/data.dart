  import 'package:path_provider/path_provider.dart';
  import 'dart:io';
  
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