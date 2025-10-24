import 'package:flutter/material.dart';

// Custom Painter REFACTORED to be generic (GrowthChartPainter)
class GrowthChartPainter extends CustomPainter {
  final List<Map<String, double>> chartData;
  final Color dataLineColor; 
  
  // Dynamic Y-Axis Parameters
  final String yAxisLabel;
  final double yAxisMax;
  final List<double> yAxisLabels;

  // Dynamic X-Axis Parameters
  final String xAxisLabel;
  final double xAxisMax;
  final List<double> xAxisLabels;


  GrowthChartPainter({
    required this.chartData, 
    required this.dataLineColor,
    required this.yAxisLabel,
    required this.yAxisMax,
    required this.yAxisLabels,
    required this.xAxisLabel, 
    required this.xAxisMax,   
    required this.xAxisLabels, 
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Constants for axis and scaling
    const double paddingX = 40.0;
    const double paddingY = 20.0;
    final double drawableWidth = size.width - paddingX;
    final double drawableHeight = size.height - paddingY;

    // Scaling functions
    final double xAxisMin = xAxisLabels.isNotEmpty ? xAxisLabels.reduce((a, b) => a < b ? a : b) : 0;
    final double xAxisRange = xAxisMax - xAxisMin;
    
    // Scale X adjusted for non-zero starting point
    double scaleX(double value) => ((value - xAxisMin) / xAxisRange) * drawableWidth + paddingX;
    
    // Uses yAxisMax passed in the constructor
    double scaleY(double value) => drawableHeight - (value / yAxisMax) * drawableHeight + paddingY;

    // --- Draw Y-Axis (Dynamic Label) and labels ---
    final Paint axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0;

    // Draw Y-axis line
    canvas.drawLine(Offset(paddingX, paddingY), Offset(paddingX, size.height), axisPaint);

    // Draw X-axis line (Umur (bulan) / Tinggi (cm))
    canvas.drawLine(Offset(paddingX, size.height), Offset(size.width, size.height), axisPaint);
    
    // Y-axis horizontal lines and labels
    for (final value in yAxisLabels) {
      final double y = scaleY(value);
      
      // Draw horizontal grid line
      canvas.drawLine(Offset(paddingX, y), Offset(size.width, y), axisPaint..color = Colors.grey.shade200);

      // Draw Y-axis label
      final TextPainter tp = TextPainter(
        text: TextSpan(text: value.toInt().toString(), style: const TextStyle(color: Colors.black, fontSize: 12)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(paddingX - tp.width - 5, y - tp.height / 2));
    }
    
    // Y-axis title
    final TextPainter tpYTitle = TextPainter(
      text: TextSpan(text: yAxisLabel, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: 100);
    canvas.save();
    canvas.translate(0, size.height / 2);
    canvas.rotate(-1.5708); // Rotate -90 degrees
    tpYTitle.paint(canvas, Offset(-tpYTitle.width / 2, 0));
    canvas.restore();


    // X-axis vertical lines and labels
    for (final value in xAxisLabels) {
      final double x = scaleX(value);
      
      // Draw vertical grid line
      canvas.drawLine(Offset(x, paddingY), Offset(x, size.height), axisPaint..color = Colors.grey.shade200);

      // Draw X-axis label
      final TextPainter tp = TextPainter(
        // Conditional text to handle '0' on X-axis and non-zero start values (like 25)
        text: TextSpan(
          text: (value == 0 && xAxisLabel.contains('Umur')) ? '0' : value.toInt().toString(), 
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      // Conditional drawing for X-axis label to ensure correct positioning
      if (value > xAxisMin || (xAxisMin == 0 && value == 0)) {
        tp.paint(canvas, Offset(x - tp.width / 2, size.height + 5));
      }
    }
    
    // --- Draw Anak Data (Empty placeholder logic remains) ---
    final Paint dataPaint = Paint()
      ..color = dataLineColor 
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final Path dataPath = Path();

    for (int i = 0; i < chartData.length; i++) {
      final double x = scaleX(chartData[i]['x']!);
      final double y = scaleY(chartData[i]['y']!);

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }

      // Draw data point circle
      canvas.drawCircle(Offset(x, y), 5.0, Paint()..color = dataLineColor); 
      canvas.drawCircle(Offset(x, y), 3.0, Paint()..color = Colors.white);
    }

    canvas.drawPath(dataPath, dataPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}