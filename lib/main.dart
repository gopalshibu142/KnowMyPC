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
  var ramdetails = {
    'maxsize' : '',
    'nos':'',
    'mfs':'',
    'freq':''
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
    result = await Process.run('cmd', ['/c', 'wmic computersystem get totalphysicalmemory']);
    ramdetails['maxsize'] =(double.parse(
      result.stdout.replaceAll('TotalPhysicalMemory', '').trim())/1073741824).toStringAsFixed(1)+" GB";
    

    setState(() {
      
    });

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
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    Text("\n\nProcessor\n\n", style: head),
              
                    Expanded(
                      
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
                          DataCell(Text(
                              (double.parse(processordetails['clock'] ?? '0') /
                                          1000)
                                      .toString() +
                                  " GHz"))
                        ]),
                      ]),
                    ),
                    Text(
                      "\n\nRAM\n\n",
                      style: TextStyle(fontSize: 20),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: DataTable2(border: TableBorder.all(), columns: [
                        DataColumn2(label: Text("Term", style: thead)),
                        DataColumn2(label: Text("Value", style: thead)),
                      ], rows: [
                        DataRow2(cells: [
                          DataCell(Text('Total RAM')),
                          DataCell(Text(ramdetails['maxsize'] ?? ''))
                        ]),
                        DataRow2(cells: [
                          DataCell(Text('Cores')),
                          DataCell(Text(processordetails['cores'] ?? ''))
                        ]),
                        DataRow2(cells: [
                          DataCell(Text('Base Clock')),
                          DataCell(Text(
                              ''))
                        ]),
                      ]),
                    ),
                    // child: Container(
                    //   alignment: Alignment.center,
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //             Text("Name Of Processor  :  "+ (processordetails['name'] ?? '')),
                    //             Text("No of Cores  :  "+(processordetails['cores'] ?? '')),
                    //             Text("Max Clock Speed  :  "+(processordetails['clock'] ?? '')),
                    //     OutlinedButton(onPressed: () {}, child: Text("GET DETAILS"))
                    //   ],
                    // ),
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
