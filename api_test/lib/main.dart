import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "Did not Call API yet.";
  _fetchText() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/hello'));
    if (response.statusCode == 200) {
      setState(() {
        result = "Response Body: ${response.body}";
      });
    } else {
      setState(() {
        result = "Request failed with status: ${response.statusCode}";
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _id = '';
  String _password = '';

  _postUser() async {
    final response = await http.post(Uri.parse('https://webhook.site/fe6742f5-29e3-41bf-96b7-2dd8aa2e3b59'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': _id,
          'password': _password,
        }));
    if (response.statusCode == 200) {
      setState(() {
        result = "SignUp Success!";
      });
    } else {
      setState(() {
        result = "Request failed with status: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  _fetchText();
                },
                child: const Text('Call API')),
            Text(result, style: const TextStyle(color: Colors.black)),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'id',
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    onSaved: (value) {
                      setState(() {
                        _id = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    onSaved: (value) {
                      setState(() {
                        _password = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _postUser();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Sent id:$_id and password:$_password to server'),
                          ),
                        );
                      }
                    },
                    child: const Text('submit'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
