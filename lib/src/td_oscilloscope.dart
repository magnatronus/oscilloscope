import 'package:flutter/material.dart';

import 'oscilloscope.dart';

/// Provides an oscilloscope type trace that is TimeDomain based
/// [timeBase] the x timebase defined as a duration
class TDOscilloscope extends StatefulWidget {
  final Duration timeBase;
  final List<num> dataSet;
  final double yAxisMin;
  final double yAxisMax;
  final Color backgroundColor;
  final Color traceColor;
  final Color yAxisColor;
  final bool showYAxis;
  final double strokeWidth;
  final EdgeInsetsGeometry margin;
  const TDOscilloscope({
    super.key,
    this.timeBase = const Duration(seconds: 1),
    this.dataSet = const [],
    this.yAxisMax = 1.0,
    this.yAxisMin = 0.0,
    this.traceColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.yAxisColor = Colors.white,
    this.showYAxis = false,
    this.strokeWidth = 2.0,
    this.margin = const EdgeInsets.all(10.0),
  });

  @override
  State<StatefulWidget> createState() => _TDOscilloscopeState();
}

class _TDOscilloscopeState extends State<TDOscilloscope> {
  @override
  Widget build(BuildContext context) {
    return Oscilloscope(
      dataSet: widget.dataSet,
      backgroundColor: widget.backgroundColor,
      yAxisMax: widget.yAxisMax,
      yAxisMin: widget.yAxisMin,
      showYAxis: widget.showYAxis,
      strokeWidth: widget.strokeWidth,
      margin: widget.margin,
      traceColor: widget.traceColor,
      yAxisColor: widget.yAxisColor,
    );
  }
}
