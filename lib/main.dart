import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  TextEditingController _controllerCep = TextEditingController();

  String _valorRetorno = "";

  void _buscaCEP() async{
    String cep = _controllerCep.text;

    var _urlApi = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    
    http.Response resposta = await http.get(_urlApi);

    String endereco = "";


    if(resposta.statusCode == 200){
        print('Código de Resposta: ${resposta.statusCode}');

        Map<String, dynamic> dadosCep = json.decode( resposta.body );

        endereco = "${dadosCep["logradouro"]}, ${dadosCep["bairro"]}, "
                          "${dadosCep["localidade"]} - ${dadosCep["uf"]} ";
      }
      else{
        endereco = 'Cep informado incorretamente ou não encontrado.';
      }

      setState(() {
        _valorRetorno = endereco;
      });

    }
  
   @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta CEP'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _controllerCep,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'CEP'),
            ),
          ),
          Text('$_valorRetorno')],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscaCEP,
        child: Icon(Icons.search),
        backgroundColor: Colors.black,
      ),
    );
  }
}

