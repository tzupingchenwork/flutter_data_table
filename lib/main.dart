import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'dart:convert';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter data table'),
      routes: {
        '/dataTable2': (context) => const DataTableExamplePage(),
      },
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/dataTable2');
          },
          child: const Text('Go to Data Table 2 example'),
        ),
      ),
    );
  }
}

class DataTableExamplePage extends StatelessWidget {
  const DataTableExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Table Example'),
      ),
      body: const Card(
        color: Color.fromARGB(255, 10, 139, 204),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: DataTableExample(),
        ),
      ),
    );
  }
}

class DataTableExample extends StatelessWidget {
  const DataTableExample({super.key});

  @override
  Widget build(BuildContext context) {
    List<dynamic> jsonData = jsonDecode(_jsonResponse);

    List<DataRow> rows = jsonData.map((jsonItem) {
      return DataRow(cells: [
        DataCell(Text(jsonItem['columnA'].toString())),
        DataCell(Text(jsonItem['columnB'].toString())),
        DataCell(Text(jsonItem['columnC'].toString())),
      ]);
    }).toList();

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      columns: const [
        DataColumn2(
          label: Text('Column A'),
          size: ColumnSize.L,
        ),
        DataColumn(
          label: Text('Column B'),
        ),
        DataColumn(
          label: Text('Column C'),
        ),
      ],
      rows: rows,
    );
  }
}

const String _jsonResponse = '''
[
  {"columnA": "Row 1A", "columnB": "Row 1B", "columnC": "Row 1C"},
  {"columnA": "Row 2A", "columnB": "Row 2B", "columnC": "Row 2C"},
  {"columnA": "Row 3A", "columnB": "Row 3B", "columnC": "Row 3C"}
]
''';
