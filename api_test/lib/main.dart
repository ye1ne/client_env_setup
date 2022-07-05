import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: HomePage(),
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
        result = "Response Body: " + response.body;
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
            Text(result, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
