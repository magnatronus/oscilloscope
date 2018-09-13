/// Demo of using the oscilloscope package
///
/// In this demo 2 displays are generated showing the outputs for Sine & Cosine
/// The scope displays will show the data sets  which will fill the yAxis and then the screen display will 'scroll'
import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Oscilloscope Display Example",
      home: Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  @override
  _ShellState createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  List<double> traceX = List();
  List<double> traceY = List();
  double radians = 0.0;
  Timer _timer;

  /// method to generate tTst  Wave Pattern Sets
  /// this gives us a value between +1  & -1 for sign & cosine
  _generateTrace(Timer t) {
    // generate our  values
    var sv = sin((radians * pi));
    var cv = cos((radians * pi));

    // Add to the growing dataset
    setState(() {
      traceX.add(sv);
      traceY.add(cv);
    });

    // adjust to recyle the radian value ( 0 = 2Pi RADS)
    radians += 0.05;
    if (radians >= 2.0) {
      radians = 0.0;
    }
  }

  @override
  initState() {
    super.initState();
    // create our timer to generate test values
    _timer = Timer.periodic(Duration(milliseconds: 60), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create A Scope Display
    Oscilloscope scopeOne = Oscilloscope(
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceX,
    );

    // Create A Scope Display
    Oscilloscope scopeTwo = Oscilloscope(
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.yellow,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceY,
    );

    // Generate the Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text("OscilloScope Demo"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: scopeOne),
          Expanded(
            flex: 1,
            child: scopeTwo,
          ),
        ],
      ),
    );
  }
}
