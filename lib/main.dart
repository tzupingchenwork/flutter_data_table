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
        '/paginatedDataTable2': (context) =>
            const PaginatedDataTableExamplePage(),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dataTable2');
              },
              child: const Text('Go to Data Table 2 example'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/paginatedDataTable2');
              },
              child: const Text('Go to paginated Data Table2 example'),
            ),
          ],
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

class PaginatedDataTableExamplePage extends StatelessWidget {
  const PaginatedDataTableExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paginated Data Table Example'),
      ),
      body: const Card(
        color: Color.fromARGB(255, 10, 139, 204),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: PaginatedDataTableExample(),
        ),
      ),
    );
  }
}

class PaginatedDataTableExample extends StatefulWidget {
  const PaginatedDataTableExample({super.key});

  @override
  State<PaginatedDataTableExample> createState() =>
      _PaginatedDataTableExampleState();
}

class _PaginatedDataTableExampleState extends State<PaginatedDataTableExample> {
  late final MyDataTableSource _dataSource;

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>> jsonData =
        List<Map<String, dynamic>>.from(jsonDecode(_jsonResponse) as List);
    _dataSource = MyDataTableSource(jsonData);
  }

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort<T>(Comparable<T> Function(Map<String, dynamic> d) getField,
      int columnIndex, bool ascending) {
    _dataSource.sort(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      columns: [
        DataColumn2(
            label: const Text('Column A'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) =>
                _sort((d) => d['columnA'], columnIndex, ascending)),
        DataColumn2(
            label: const Text('Column B'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) =>
                _sort((d) => d['columnB'], columnIndex, ascending)),
        DataColumn2(
            label: const Text('Column C'),
            size: ColumnSize.L,
            onSort: (columnIndex, ascending) =>
                _sort((d) => d['columnC'], columnIndex, ascending)),
      ],
      rowsPerPage: 2,
      source: _dataSource,
    );
  }
}

class MyDataTableSource extends DataTableSource {
  MyDataTableSource(this._rows);

  final List<Map<String, dynamic>> _rows;

  void sort<T>(
      Comparable<T> Function(Map<String, dynamic> d) getField, bool ascending) {
    _rows.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    if (index >= _rows.length) return const DataRow(cells: []);
    return DataRow(cells: [
      DataCell(Text(_rows[index]['columnA'].toString())),
      DataCell(Text(_rows[index]['columnB'].toString())),
      DataCell(Text(_rows[index]['columnC'].toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}
