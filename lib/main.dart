// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';

import 'package:data_table_2/data_table_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMaxWindowSize(Size(600, 800));
  runApp(const KMP());
}

class KMP extends StatefulWidget {
  const KMP({super.key});

  @override
  State<KMP> createState() => _KMPState();
}

class _KMPState extends State<KMP> {
  var ram = '';
  var processordetails = {
    'name': '',
    'clock': '',
    'cores': '',
  };
  Map ramdetails = {
    'maxsize': '',
    'availsize': '',
    'nos': '',
    'mfs': '',
    'freq': [],
    'manufacturer': [],
  };
//wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed, status
  void getDetails() async {
    var result;
    result = await Process.run('cmd', ['/c', 'wmic cpu get name']);
    processordetails['name'] = result.stdout.replaceAll('Name', '').trim();
    result = await Process.run('cmd', ['/c', 'wmic cpu get maxclockspeed']);
    processordetails['clock'] =
        result.stdout.replaceAll('MaxClockSpeed', '').trim();
    result = await Process.run('cmd', ['/c', 'wmic cpu get numberofcores']);
    processordetails['cores'] =
        result.stdout.replaceAll('NumberOfCores', '').trim();
    result = await Process.run(
        'cmd', ['/c', 'wmic computersystem get totalphysicalmemory']);
    ramdetails['availsize'] = (double.parse(result.stdout
                    .replaceAll('TotalPhysicalMemory', '')
                    .trim()) /
                1073741824)
            .toStringAsFixed(1) +
        " GB";
    ramdetails['maxsize'] = ((double.parse(result.stdout
                    .replaceAll('TotalPhysicalMemory', '')
                    .trim()) /
                1073741824))
            .ceil()
            .toStringAsFixed(1) +
        " GB";
    result = await Process.run('cmd', ['/c', 'wmic memorychip get speed']);
    ramdetails['freq'] =
        result.stdout.replaceAll('Speed', '').trim().split('\n');
    result =
        await Process.run('cmd', ['/c', 'wmic memorychip get manufacturer']);
    ramdetails['manufacturer'] =
        result.stdout.replaceAll('Manufacturer', '').trim().split('\n');

    setState(() {});
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  TextStyle head = const TextStyle(fontSize: 25);
  TextStyle thead = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Expanded(
              child: Center(
                child: ListView(
                  children: [
                    Text("\n\nProcessor\n\n", style: head),
                    Container(
                      height: 200,
                      child: Expanded(
                        child: DataTable2(border: TableBorder.all(), columns: [
                          DataColumn2(label: Text("Term", style: thead)),
                          DataColumn2(label: Text("Value", style: thead)),
                        ], rows: [
                          DataRow2(cells: [
                            DataCell(Text('Name')),
                            DataCell(Text(processordetails['name'] ?? ''))
                          ]),
                          DataRow2(cells: [
                            DataCell(Text('Cores')),
                            DataCell(Text(processordetails['cores'] ?? ''))
                          ]),
                          DataRow2(cells: [
                            DataCell(Text('Base Clock')),
                            DataCell(Text((double.parse(
                                            processordetails['clock'] ?? '0') /
                                        1000)
                                    .toString() +
                                " GHz"))
                          ]),
                        ]),
                      ),
                    ),
                    Text(
                      "\n\nRAM\n\n",
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      height: 300,
                      child: Flexible(
                        fit: FlexFit.tight,
                        child: DataTable2(border: TableBorder.all(), columns: [
                          DataColumn2(label: Text("Term", style: thead)),
                          DataColumn2(label: Text("Value", style: thead)),
                        ], rows: [
                          DataRow2(cells: [
                            DataCell(Text('Total RAM')),
                            DataCell(Text(ramdetails['maxsize'].toString()))
                          ]),
                          DataRow2(cells: [
                            DataCell(Text('Available RAM')),
                            DataCell(Text(ramdetails['availsize'].toString()))
                          ]),
                          DataRow2(cells: [
                            DataCell(Text('Slots used')),
                            DataCell(Text(ramdetails['manufacturer'].length.toString()))
                          ]),
                          DataRow2(cells: [
                            DataCell(Text('Speed(MHz)')),
                            DataCell(Text(ramdetails['freq'].toString()))
                          ]),
                          DataRow2(cells: [
                            DataCell(Text('Manufacturer')),
                            DataCell(Text((ramdetails['manufacturer']).toString()))
                          ]),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //)
          ],
        ),
      ),
    );
  }
}
