import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const KMP());
}

class KMP extends StatefulWidget {
  const KMP({super.key});

  @override
  State<KMP> createState() => _KMPState();
}

class _KMPState extends State<KMP> {
  var ram;
  var processor;

  void getDetails() async {
    processor = await Process.run('cmd', ['/c', 'wmic cpu get name']);
    debugPrint(processor.stdout);
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(processor)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
