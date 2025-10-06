import 'dart:async';
import 'dart:math';

/// Demo of using the oscilloscope package
///
/// In this demo 2 displays are generated showing the outputs for Sine & Cosine
/// The scope displays will show the data sets  which will fill the yAxis and then the screen display will 'scroll'
import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Oscilloscope Display Example", home: Shell());
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<StatefulWidget> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  List<double> traceSine = [];
  List<double> traceCosine = [];
  double radians = 0.0;
  Timer? _timer;

  /// method to generate a Test  Wave Pattern Sets
  /// this gives us a value between +1  & -1 for sine & cosine
  _generateTrace(Timer t) {
    // generate our  values
    var sv = sin((radians * pi));
    var cv = cos((radians * pi));

    // Add to the growing dataset
    setState(() {
      traceSine.add(sv);
      traceCosine.add(cv);
    });

    // adjust to recyle the radian value ( as 0 = 2Pi RADS)
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
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create A Scope Display for Sine
    Oscilloscope scopeOne = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.orange,
      margin: EdgeInsets.all(10.0),
      strokeWidth: 1.0,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceSine,
    );

    // Create A Scope Display for Cosine
    Oscilloscope scopeTwo = Oscilloscope(
      showYAxis: true,
      margin: EdgeInsets.all(10.0),
      strokeWidth: 3.0,
      backgroundColor: Colors.black,
      traceColor: Colors.yellow,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceCosine,
    );

    // create a Timedomain scope
    TDOscilloscope scopeThree = TDOscilloscope(
      showYAxis: true,
      margin: EdgeInsets.all(10.0),
      strokeWidth: 2.0,
      backgroundColor: Colors.black,
      traceColor: Colors.pink,
      yAxisColor: Colors.blue,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceCosine,
    );

    // Generate the Scaffold
    return Scaffold(
      appBar: AppBar(title: Text("OscilloScope Demo")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: <Widget>[
              SizedBox(height: constraints.maxHeight / 3, child: scopeThree),
              SizedBox(height: constraints.maxHeight / 3, child: scopeTwo),
              SizedBox(height: constraints.maxHeight / 3, child: scopeOne),
            ],
          );
        },
      ),
    );
  }
}
