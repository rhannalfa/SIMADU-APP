import 'package:flutter/material.dart';
import 'anak_page.dart'; // Contains the Anak class
import 'growth_chart_widgets.dart'; // New file for chart builders and utilities

// 1. CONVERTED TO STATEFULWIDGET TO MANAGE TAB STATE
class GrowthChartModal extends StatefulWidget {
  final Anak anak;
  const GrowthChartModal({super.key, required this.anak});

  @override
  State<GrowthChartModal> createState() => _GrowthChartModalState();
}

class _GrowthChartModalState extends State<GrowthChartModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 3 tabs
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder data for demonstration, replace with actual logic later
    final giziStatus = 'Gizi Baik';
    final trendStatus = 'Naik';
    final trendColor = Colors.green; 

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: Column(
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Grafik Pertumbuhan - ${widget.anak.name}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 10, thickness: 1),
              
              // --- Content Area ---
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Cards (now using external function)
                      buildStatusCard(
                        title: 'Status Gizi',
                        statusText: giziStatus,
                        statusColor: trendColor,
                        trailingWidget: buildStatusBadge('Normal', color: trendColor),
                      ),
                      buildStatusCard(
                        title: 'Tren Berat Badan',
                        statusText: trendStatus,
                        statusColor: trendColor,
                        trailingWidget: null,
                      ),
                      buildStatusCard(
                        title: 'Tren Tinggi Badan',
                        statusText: trendStatus,
                        statusColor: trendColor,
                        trailingWidget: null,
                      ),

                      // --- Growth Chart Container ---
                      const SizedBox(height: 20),
                      Card(
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
                              // Chart Title and Zones Description
                              const Text(
                                'Grafik Pertumbuhan (Standar WHO)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Zona hijau = Normal, Zona kuning = Perlu perhatian, Zona merah = Perlu tindakan',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 16),

                              // 3. Tab Bar for BB/U, TB/U, BB/TB
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  // Style the indicator to match the segmented control look
                                  indicator: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface, // Background of the selected tab
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey.shade300, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey.shade600,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabs: const [
                                    Tab(text: 'BB/U'),
                                    Tab(text: 'TB/U'),
                                    Tab(text: 'BB/TB'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 4. Tab Bar View Content (now using external functions)
                              SizedBox(
                                height: 470, 
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    buildBBUChart(context), 
                                    buildTBUChart(context), 
                                    buildBBTBChart(context),
                                  ],
                                ),
                              ),
                              
                              // --- RECOMMENDATION SECTION (from the image) ---
                              const SizedBox(height: 25),
                              buildRecommendationBox(), // Using external function
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}