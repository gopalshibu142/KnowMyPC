// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:animated_background/animated_background.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMaxWindowSize(Size(600, 800));
  runApp(MaterialApp(
      theme: ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          radius: Radius.circular(100),
          thumbColor: MaterialStateColor.resolveWith((states) => Colors.red),
          trackColor: MaterialStateColor.resolveWith((states) => Colors.grey),
        ),
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
        accentColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          bodyText2: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[800],
          filled: true,
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: Landing()));
}

var processordetails = {
  'name': '',
  'clock': '',
  'cores': '',
};
Map ramdetails = {
  'maxsize': '',
  'availsize': '',
  'nos': '',
  'tno': '',
  'mfs': '',
  'freq': [],
  'maxcap': '',
  'manufacturer': [],
  'sizeeach': []
};

Future getDetails() async {
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
  ramdetails['availsize'] = (double.parse(
                  result.stdout.replaceAll('TotalPhysicalMemory', '').trim()) /
              1073741824)
          .toStringAsFixed(1) +
      " GB";
  ramdetails['maxsize'] = ((double.parse(
                  result.stdout.replaceAll('TotalPhysicalMemory', '').trim()) /
              1073741824))
          .ceil()
          .toStringAsFixed(1) +
      " GB";
  result = await Process.run('cmd', ['/c', 'wmic memorychip get speed']);
  ramdetails['freq'] = result.stdout.replaceAll('Speed', '').trim().split('\n');
  result = await Process.run('cmd', ['/c', 'wmic memorychip get manufacturer']);
  ramdetails['manufacturer'] =
      result.stdout.replaceAll('Manufacturer', '').trim().split('\n');
  result = await Process.run('cmd', ['/c', 'wmic memorychip get capacity']);
  List l = result.stdout.replaceAll('Capacity', '').trim().split('\n');
  // l.forEach((i) {
  for (int i = 0; i < l.length; i++) {
    l[i] = (double.parse(l[i]) / 1073741824).toString();
  }
  //   // l[i] = (double.parse(l[i]) / 1073741824).toString();
  // });
  ramdetails['sizeeach'] = l;
  result = await Process.run('cmd', ['/c', 'wmic Memphysical get MemoryDevices']);
  ramdetails['tno'] = result.stdout.replaceAll('MemoryDevices', '').trim();
  result = await Process.run('cmd', ['/c', 'wmic Memphysical get MaxCapacity ']);
  ramdetails['maxcap'] = (int.parse(result.stdout.replaceAll('MaxCapacity', '').trim())/1048576).toStringAsFixed(0);
}

class KMP extends StatefulWidget {
  const KMP({super.key});

  @override
  State<KMP> createState() => _KMPState();
}

class _KMPState extends State<KMP> {
  var ram = '';

//wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed, status

  @override
  void initState() {
    super.initState();
    getDetails();
    setState(() {});
  }

  TextStyle head = const TextStyle(fontSize: 25);
  TextStyle thead = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KnowYourPC"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text("\n\n\tProcessor\n\n", style: head),
              DataTable(border: TableBorder.all(), columns: [
                DataColumn(label: Text("Term", style: thead)),
                DataColumn(label: Text("Value", style: thead)),
              ], rows: [
                DataRow(cells: [
                  DataCell(Text('Name')),
                  DataCell(Text(processordetails['name'] ?? ''))
                ]),
                DataRow(cells: [
                  DataCell(Text('Cores')),
                  DataCell(Text(processordetails['cores'] ?? ''))
                ]),
                DataRow(cells: [
                  DataCell(Text('Base Clock')),
                  DataCell(Text(
                      (double.parse(processordetails['clock'] ?? '0') / 1000)
                              .toString() +
                          " GHz"))
                ]),
              ]),
              Text(
                "\n\n\tRAM\n\n",
                style: TextStyle(fontSize: 20),
              ),
              DataTable(border: TableBorder.all(), columns: [
                DataColumn(label: Text("Term", style: thead)),
                DataColumn(label: Text("Value", style: thead)),
              ], rows: [
                DataRow(cells: [
                  DataCell(Text('Total RAM')),
                  DataCell(Text(ramdetails['maxsize'].toString()))
                ]),
                DataRow(cells: [
                  DataCell(Text('Available RAM')),
                  DataCell(Text(ramdetails['availsize'].toString()))
                ]),
                DataRow(cells: [
                  DataCell(Text('Slots used/total')),
                  DataCell(Text(ramdetails['manufacturer'].length.toString()+'/'+ramdetails['tno']))
                ]),
                DataRow(cells: [
                  DataCell(Text('Ram Size (Each Slot)')),
                  DataCell(Text((ramdetails['sizeeach']).toString()))
                ]),
                DataRow(cells: [
                  DataCell(Text('Speed(MHz)')),
                  DataCell(Text(ramdetails['freq'].toString()))
                ]),
                DataRow(cells: [
                  DataCell(Text('Manufacturer')),
                  DataCell(Text((ramdetails['manufacturer']).toString()))
                ]),
                 DataRow(cells: [
                  DataCell(Text('Total Supported')),
                  DataCell(Text((ramdetails['maxcap']).toString()+"GB"))
                ]),
              ]),
              Text(
                "\n\n\tGraphics\n\n",
                style: TextStyle(fontSize: 20),
              ),
              DataTable(border: TableBorder.all(), columns: [
                DataColumn(label: Text("Term", style: thead)),
                DataColumn(label: Text("Value", style: thead)),
              ], rows: [
                DataRow(cells: [
                  DataCell(Text('Available GPUs')),
                  DataCell(Text(processordetails['name'] ?? ''))
                ]),
                DataRow(cells: [
                  DataCell(Text('Cores')),
                  DataCell(Text(processordetails['cores'] ?? ''))
                ]),
                DataRow(cells: [
                  DataCell(Text('Base Clock')),
                  DataCell(Text(
                      (double.parse(processordetails['clock'] ?? '0') / 1000)
                              .toString() +
                          " GHz"))
                ]),
              ]),
              SizedBox(height: 150,)
            ],
          ),
        ),
      ),
    );

    //)
  }
}

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> with TickerProviderStateMixin {
  var plswait = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
          child: Center(
            child: GlassmorphicContainer(
              width: 250,
              height: 300,
              borderRadius: 20,
              blur: 0.1,
              padding: EdgeInsets.all(40),
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFffffff).withOpacity(0.1),
                    Color(0xFFFFFFFF).withOpacity(0.05),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                  Color((0xff000000)).withOpacity(0.5),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Say goodbye to \'I don\'t know!'),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        setState(() {
                          plswait = "hold tight";
                        });
                        getDetails().then((value) {
                          setState(() {
                            plswait = "";
                          });

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => KMP()));
                        });
                      },
                      child: Text(
                        'KnowMyPC',
                        style: TextStyle(),
                      )),
                  Text(plswait)
                ],
              ),
            ),
          ),
          vsync: this,
          behaviour: SpaceBehaviour()),
    );
  }
}
