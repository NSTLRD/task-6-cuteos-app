import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';


class UniversityPage extends StatefulWidget {
  @override
  _UniversityPageState createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage> {
  TextEditingController _countryController = TextEditingController();
  List universities = [];

  Future<void> fetchUniversities(String country) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    http.Client ioClient = new IOClient(client);
    final response = await ioClient.get(Uri.parse('http://universities.hipolabs.com/search?country=$country'));

    if (response.statusCode == 200) {
      setState(() {
        universities = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () => fetchUniversities(_countryController.text.trim()),
              child: Text('Search Universities'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: universities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(universities[index]['name']),
                    subtitle: Text(universities[index]['domain']),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => launch(universities[index]['web_pages'][0]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
