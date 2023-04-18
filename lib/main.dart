import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Map<String, dynamic>>> _fetchData() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'KKCK',
      db: 'claseCarreon',
    ));

    final results = await conn.query('SELECT * FROM colegas');
    await conn.close();

    return results.map((row) => row.fields).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final colega = snapshot.data![index];
                return ListTile(
                  title: Text('${colega['nombre']} ${colega['apellido_paterno']}'),
                  subtitle: Text('${colega['sexo']}, ${colega['edad']} años'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

