// Copyright (c) 2018, Steve Rogers. All rights reserved. Use of this source code
// is governed by an Apache License 2.0 that can be found in the LICENSE file.
library oscilloscope;

import 'package:flutter/material.dart';

/// A widget that defines a customisable Oscilloscope type display that can be used to graph out data
///
/// The [dataSet] arguments MUST be a List<double> -  this is the data that is used by the display to generate a trace
///
/// All other arguments are optional as they have preset values
///
/// [showYAxis] this will display a line along the yAxisat 0 if the value is set to true (default is false)
/// [yAxisColor] determines the color of the displayed yAxis (default value is Colors.white)
///
/// [yAxisMin] and [yAxisMax] although optional should be set to reflect the data that is supplied in [dataSet]. These values
/// should be set to the min and max values in the supplied [dataSet].
///
/// For example if the max value in the data set is 2.5 and the min is -3.25  then you should set [yAxisMin] = -3.25 and [yAxisMax] = 2.5
/// This allows the oscilloscope display to scale the generated graph correctly.
///
/// You can modify the background color of the oscilloscope with the [backgroundColor] argument and the color of the trace with [traceColor]
///
/// The [padding] argument allows space to be set around the display (this defaults to 10.0 if not specified)
///
/// NB: This is not a Time Domain trace, the update frequency of the supplied [dataSet] determines the trace speed.
class Oscilloscope extends StatefulWidget {
  final List<double> dataSet;
  final double yAxisMin;
  final double yAxisMax;
  final double padding;
  final Color backgroundColor;
  final Color traceColor;
  final Color yAxisColor;
  final bool showYAxis;

  Oscilloscope(
      {this.traceColor = Colors.white,
      this.backgroundColor = Colors.black,
      this.yAxisColor = Colors.white,
      this.padding = 10.0,
      this.yAxisMax = 1.0,
      this.yAxisMin = 0.0,
      this.showYAxis = false,
      @required this.dataSet});

  @override
  _OscilloscopeState createState() => _OscilloscopeState();
}

class _OscilloscopeState extends State<Oscilloscope> {
  double yRange;
  double yScale;

  @override
  void initState() {
    super.initState();
    yRange = widget.yAxisMax - widget.yAxisMin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding),
      width: double.infinity,
      height: double.infinity,
      color: widget.backgroundColor,
      child: ClipRect(
        child: CustomPaint(
          painter: _TracePainter(
              showYAxis: widget.showYAxis,
              yAxisColor: widget.yAxisColor,
              dataSet: widget.dataSet,
              traceColor: widget.traceColor,
              yMin: widget.yAxisMin,
              yRange: yRange),
        ),
      ),
    );
  }
}

/// A Custom Painter used to generate the trace line from the supplied dataset
class _TracePainter extends CustomPainter {
  final List dataSet;
  final double xScale;
  final double yMin;
  final Color traceColor;
  final Color yAxisColor;
  final bool showYAxis;
  final double yRange;

  _TracePainter(
      {this.showYAxis,
      this.yAxisColor,
      this.yRange,
      this.yMin,
      this.dataSet,
      this.xScale = 1.0,
      this.traceColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..strokeWidth = 1.0
      ..color = yAxisColor;

    double yScale = (size.height / yRange);

    // only start plot if dataset has data
    int length = dataSet.length;
    if (length > 0) {
      // transform data set to just what we need if bigger than the width(otherwise this would be a memory hog)
      if (length > size.width) {
        dataSet.removeAt(0);
        length = dataSet.length;
      }

      // Create Path and set Origin to first data point
      Path trace = Path();
      trace.moveTo(0.0, size.height - (dataSet[0].toDouble() - yMin) * yScale);

      // generate trace path
      for (int p = 0; p < length; p++) {
        double plotPoint =
            size.height - ((dataSet[p].toDouble() - yMin) * yScale);
        trace.lineTo(p.toDouble() * xScale, plotPoint);
      }

      // display the trace
      canvas.drawPath(trace, tracePaint);

      // if yAxis required draw it here
      if (showYAxis) {
        Offset yStart = Offset(0.0, size.height - (0.0 - yMin) * yScale);
        Offset yEnd = Offset(size.width, size.height - (0.0 - yMin) * yScale);
        canvas.drawLine(yStart, yEnd, axisPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}
