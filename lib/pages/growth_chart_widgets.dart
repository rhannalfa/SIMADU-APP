import 'package:flutter/material.dart';
import 'growth_chart_painter.dart';

// Helper for line-style legend 
Widget buildLegendItem({required Color color, required String label}) {
  return Row(
    mainAxisSize: MainAxisSize.min, // Ensure the row only takes the space it needs
    children: [
      Container(width: 10, height: 2, color: color),
      Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      Container(width: 10, height: 2, color: color),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}

// Helper for checkbox-style legend 
Widget buildLegendCheckbox({required Color color, required String label, required bool isChecked}) {
  return Row(
    mainAxisSize: MainAxisSize.min, // Ensure the row only takes the space it needs
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          border: Border.all(color: color),
          color: isChecked ? color.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}


// --- 2A. BB/U Chart Widget ---
Widget buildBBUChart(BuildContext context) {
  // Parameter Khusus BB/U
  const String yAxisLabel = 'Berat (kg)';
  const double yAxisMax = 16.0;
  const List<double> yAxisLabels = [0, 4, 8, 12, 16]; 
  
  // X-axis: Umur (bulan), Max 18, Labels: 0, 3, 6, 9, 12, 15, 18
  const String xAxisLabel = 'Umur (bulan)';
  const double xAxisMax = 18.0;
  const List<double> xAxisLabels = [0, 3, 6, 9, 12, 15, 18];

  final List<Map<String, double>> chartData = []; 
  final Color dataLineColor = Theme.of(context).primaryColor; 

  return Column(
    children: [
      SizedBox(
        height: 300, 
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, bottom: 5, left: 20),
          child: CustomPaint(
            // Panggil GrowthChartPainter dengan parameter BB/U
            painter: GrowthChartPainter(
              chartData: chartData,
              dataLineColor: dataLineColor,
              yAxisLabel: yAxisLabel,
              yAxisMax: yAxisMax,
              yAxisLabels: yAxisLabels,
              xAxisLabel: xAxisLabel,
              xAxisMax: xAxisMax,
              xAxisLabels: xAxisLabels,
            ),
          ),
        ),
      ),
      
      // X-axis Title 
      const SizedBox(height: 25), 
      Text(
        xAxisLabel,
        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5), 
      
      // --- Chart Legend ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            // 1. WHO Lines
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0, 
              runSpacing: 8.0, 
              children: [
                buildLegendItem(color: Colors.red.shade400, label: 'Batas Atas WHO'),
                buildLegendItem(color: Colors.orange.shade400, label: 'Batas Bawah WHO'),
                buildLegendItem(color: Colors.green.shade400, label: 'Normal WHO'),
                buildLegendItem(color: Colors.blue.shade400, label: 'Berat Anak'),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 2. Anak Status Legend (Checkbox row) - BB/U specific
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0, 
              runSpacing: 8.0, 
              children: [
                buildLegendCheckbox(color: Colors.red.shade400, label: 'Di atas normal', isChecked: true),
                buildLegendCheckbox(color: Colors.green.shade400, label: 'Normal', isChecked: true),
                buildLegendCheckbox(color: Colors.orange.shade400, label: 'Di bawah normal', isChecked: true),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// --- 2B. TB/U Chart Widget ---
Widget buildTBUChart(BuildContext context) {
  // Parameter Khusus TB/U
  const String yAxisLabel = 'Tinggi (cm)';
  const double yAxisMax = 100.0;
  const List<double> yAxisLabels = [0, 25, 50, 75, 100]; 
  
  // X-axis: Umur (bulan), Max 18, Labels: 0, 3, 6, 9, 12, 15, 18
  const String xAxisLabel = 'Umur (bulan)';
  const double xAxisMax = 18.0;
  const List<double> xAxisLabels = [0, 3, 6, 9, 12, 15, 18];

  final List<Map<String, double>> chartData = []; 
  final Color dataLineColor = Theme.of(context).primaryColor; 

  return Column(
    children: [
      SizedBox(
        height: 300, 
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, bottom: 5, left: 20),
          child: CustomPaint(
            // Panggil GrowthChartPainter dengan parameter TB/U
            painter: GrowthChartPainter(
              chartData: chartData,
              dataLineColor: dataLineColor,
              yAxisLabel: yAxisLabel,
              yAxisMax: yAxisMax,
              yAxisLabels: yAxisLabels,
              xAxisLabel: xAxisLabel,
              xAxisMax: xAxisMax,
              xAxisLabels: xAxisLabels,
            ),
          ),
        ),
      ),
      
      // X-axis Title 
      const SizedBox(height: 25), 
      Text(
        xAxisLabel,
        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5), 
      
      // --- Chart Legend ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            // 1. WHO Lines
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0, 
              runSpacing: 8.0, 
              children: [
                buildLegendItem(color: Colors.red.shade400, label: 'Batas Atas WHO'),
                buildLegendItem(color: Colors.orange.shade400, label: 'Batas Bawah WHO'),
                buildLegendItem(color: Colors.green.shade400, label: 'Normal WHO'),
                buildLegendItem(color: Colors.blue.shade400, label: 'Tinggi Anak'),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 2. Anak Status Legend (Checkbox row) - TB/U specific
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0, 
              runSpacing: 8.0, 
              children: [
                buildLegendCheckbox(color: Colors.red.shade400, label: 'Tinggi', isChecked: true),
                buildLegendCheckbox(color: Colors.green.shade400, label: 'Normal', isChecked: true),
                buildLegendCheckbox(color: Colors.orange.shade400, label: 'Pendek/Stunting', isChecked: true),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// --- 2C. BB/TB Chart Widget ---
Widget buildBBTBChart(BuildContext context) {
  // Y-axis: Sama seperti BB/U (Berat (kg), Max 16)
  const String yAxisLabel = 'Berat (kg)';
  const double yAxisMax = 16.0;
  const List<double> yAxisLabels = [0, 4, 8, 12, 16]; 
  
  // X-axis: Tinggi (cm), Max 175, Labels: 25, 50, 75, 100, 125, 150, 175
  const String xAxisLabel = 'Tinggi (cm)';
  const double xAxisMax = 175.0; 
  const List<double> xAxisLabels = [25, 50, 75, 100, 125, 150, 175]; 

  final List<Map<String, double>> chartData = []; 
  final Color dataLineColor = Theme.of(context).primaryColor; 

  return Column(
    children: [
      SizedBox(
        height: 300, 
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, bottom: 5, left: 20),
          child: CustomPaint(
            // Panggil GrowthChartPainter dengan parameter BB/TB
            painter: GrowthChartPainter(
              chartData: chartData,
              dataLineColor: dataLineColor,
              yAxisLabel: yAxisLabel,
              yAxisMax: yAxisMax,
              yAxisLabels: yAxisLabels,
              xAxisLabel: xAxisLabel,
              xAxisMax: xAxisMax,
              xAxisLabels: xAxisLabels,
            ),
          ),
        ),
      ),
      
      // X-axis Title 
      const SizedBox(height: 25), 
      Text(
        xAxisLabel,
        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5), 
      
      // --- Chart Legend ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            // 1. WHO Lines (Legend Item Labels UPDATED) 
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0, 
              runSpacing: 8.0, 
              children: [
                buildLegendItem(color: Colors.red.shade400, label: 'Obesitas'),
                buildLegendItem(color: Colors.orange.shade400, label: 'Kurus'),
                buildLegendItem(color: Colors.green.shade400, label: 'Normal'),
                buildLegendItem(color: Colors.blue.shade400, label: 'Berat Anak'),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 2. Anak Status Legend (Checkbox row) - BB/TB specific
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.0, 
              runSpacing: 8.0, 
              children: [
                buildLegendCheckbox(color: Colors.red.shade400, label: 'Obesitas', isChecked: true),
                buildLegendCheckbox(color: Colors.green.shade400, label: 'Normal', isChecked: true),
                buildLegendCheckbox(color: Colors.orange.shade400, label: 'Kurus', isChecked: true),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// Utility Widget: Status Card for Gizi/Tren
Widget buildStatusCard({
  required String title,
  required String statusText,
  required Color statusColor,
  Widget? trailingWidget,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12.0),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  if (title.contains('Tren')) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.trending_up, color: statusColor, size: 24),
                  ],
                ],
              ),
              if (trailingWidget != null) trailingWidget,
            ],
          ),
        ],
      ),
    ),
  );
}

// Utility Widget: Status Badge ("Normal")
Widget buildStatusBadge(String text, {required Color color}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: color, width: 1),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

// Widget to display the Recommendation Box
Widget buildRecommendationBox() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              'Rekomendasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '• Pertumbuhan Aisyah Putri berada dalam kategori normal',
          style: TextStyle(fontSize: 14),
        ),
        const Text(
          '• Lanjutkan pemberian ASI/makanan bergizi seimbang',
          style: TextStyle(fontSize: 14),
        ),
        const Text(
          '• Pastikan Aisyah Putri mendapatkan imunisasi sesuai jadwal',
          style: TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}