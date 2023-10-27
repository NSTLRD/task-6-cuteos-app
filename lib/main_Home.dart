/*
* @params
* starling javier diaz aquino
* matricula 20210416
*
* */

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';


import 'MyHomePage.dart';

void main() {
  runApp(MaterialApp(
    home: MyHomePage(),
  ));
}


class main_Home extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<main_Home> {
  TextEditingController _nameController = TextEditingController();
  String _gender = '';
  String _imageUrl = '';

  Future<void> predictGender(String name) async {
    // Deshabilitar la verificación de certificados SSL (No seguro!)
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    http.Client ioClient = new IOClient(client);
    final response = await ioClient.get(
        Uri.parse('https://api.genderize.io/?name=$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _gender = data['gender'];
        _imageUrl = _gender == 'male'
            ? 'https://unsplash.com/es/fotos/pintura-abstracta-rosa-y-blanca-2PN18U8CKi0' // Reemplaza con la URL de la imagen azul
            : 'https://unsplash.com/es/fotos/un-fondo-azul-y-purpura-con-formas-onduladas-QoC724KNv6A'; // Reemplaza con la URL de la imagen rosa
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Se ha eliminado el AppBar
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView( // Envuelto con SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Ingrese un nombre para predecir el género:',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      predictGender(name);
                    }
                  },
                  child: Text('Predecir Género'),
                ),
                SizedBox(height: 16.0),
                _gender.isNotEmpty
                    ? Text(
                  'Género: $_gender',
                  style: TextStyle(fontSize: 24.0),
                )
                    : SizedBox(),
                SizedBox(height: 16.0),
                _imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: _imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}