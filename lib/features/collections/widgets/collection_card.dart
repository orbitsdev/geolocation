import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';
import 'package:get/get.dart';

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollectionCard({
    Key? key,
    required this.collection,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title, Date, and Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    collection.lastUpdated ?? 'No Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Total Amount: ${collection.formattedTotalAmount()}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Optional Description
          if (collection.description != null) ...[
            Text(
              collection.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Chart
          SizedBox(
            height: 200,
            child: _buildChart(collection.type ?? 'Pie Chart', collection.items),
          ),
        ],
      ),
    );
  }

  /// Builds the chart based on the collection type.
  Widget _buildChart(String chartType, List<CollectionItem>? items) {
    final data = items?.map((e) => e.amount?.toDouble() ?? 0.0).toList() ?? [];
    final labels = items?.map((e) => e.label ?? 'No Label').toList() ?? [];

    if (data.isEmpty || data.every((value) => value <= 0)) {
      return const Center(child: Text('No data available for the chart.'));
    }

    switch (chartType) {
      case 'Pie Chart':
        return PieChart(
          PieChartData(
            sections: _buildPieChartSections(data, labels),
            borderData: FlBorderData(show: false),
            sectionsSpace: 4,
            centerSpaceRadius: 40,
          ),
        );
      case 'Bar Chart':
      return BarChart(
        BarChartData(
          maxY: (data.reduce((a, b) => a > b ? a : b) * 1.2), // Scale Y-axis
          barGroups: _buildBarChartGroups(data),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget:  Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Amount Spent', style: Get.textTheme.bodyMedium?.copyWith(), ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                interval: _calculateInterval(data),
                getTitlesWidget: (value, meta) {
                  if (value >= 1000) {
                    return Text('${(value / 1000).toStringAsFixed(1)}K',
                        style: const TextStyle(fontSize: 12));
                  }
                  return Text(value.toInt().toString(),
                      style: const TextStyle(fontSize: 12));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Items', style: TextStyle(fontSize: 14)),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return index < labels.length
                      ? Text(labels[index], style: const TextStyle(fontSize: 12))
                      : const Text('');
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
          
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final itemLabel = labels[group.x.toInt()];
                return BarTooltipItem(
                  '$itemLabel\n${rod.toY.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      );
        case 'Line Chart':
    return LineChart(
      LineChartData(
        lineBarsData: _buildLineChartData(data),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _calculateInterval(data),
              getTitlesWidget: (value, meta) {
                return Text(value.toStringAsFixed(0));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                return index < labels.length
                    ? Text(labels[index], style: const TextStyle(fontSize: 12))
                    : const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
      ),
    );
      default:
        return const Center(child: Text('Invalid chart type.'));
    }
  }

  List<LineChartBarData> _buildLineChartData(List<double> data) {
  return [
    LineChartBarData(
      spots: List.generate(
        data.length,
        (index) => FlSpot(index.toDouble(), data[index]),
      ),
      isCurved: true, // Makes the line smooth
      color: Colors.blue,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
      dotData: FlDotData(show: true),
    ),
  ];
}


  /// Builds sections for the pie chart.
  List<PieChartSectionData> _buildPieChartSections(
    List<double> data, List<String> labels) {
  final total = data.reduce((a, b) => a + b);
  return List.generate(data.length, (index) {
    final percentage = ((data[index] / total) * 100).toStringAsFixed(1);
    return PieChartSectionData(
      color: _getColor(index),
      value: data[index],
      title: '$percentage%\n(${data[index].toStringAsFixed(0)})',
      radius: 60, // Adjusted for better spacing
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  });
}

 double _calculateInterval(List<double> data) {
  if (data.isEmpty) return 1;
  final maxY = data.reduce((a, b) => a > b ? a : b);
  return (maxY / 4).ceilToDouble(); // Divide into 4 intervals
}

/// Builds groups for the bar chart.
List<BarChartGroupData> _buildBarChartGroups(List<double> data) {
  return List.generate(data.length, (i) {
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          toY: data[i],
          color: _getColor(i),
          width: 20,
          borderRadius: BorderRadius.circular(4), // Rounded bars
        ),
      ],
      showingTooltipIndicators: [0],
    );
  });
}


/// Retrieves a color for the chart sections/bars.
Color _getColor(int index) {
  switch (index % 3) { // Cycle through 3 colors
    case 0:
      return Colors.green;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
}
