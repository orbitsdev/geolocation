import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/helpers/formmater.dart';
import 'package:geolocation/core/theme/palette.dart';
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
   // Extract data and labels from collection items
  final data = items?.map((e) => e.amount?.toDouble() ?? 0.0).toList() ?? [];
  final labels = items?.map((e) => e.label ?? 'No Label').toList() ?? [];

  // Check for empty or invalid data
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
        centerSpaceRadius: 50, // Adjusted for better visibility
        centerSpaceColor: Colors.white, // Ensures center has a clean background
      ),
    );

      case 'Bar Chart':
     return BarChart(
  BarChartData(
    maxY: data.reduce((a, b) => a > b ? a : b) * 1.1, // Add 10% padding for better visibility
    barGroups: _buildBarChartGroups(data),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            // Display numbers with "₱" symbol
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '₱${value.toStringAsFixed(0)}',
                style:  TextStyle(fontSize: 10, color: Palette.PRIMARY),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < labels.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  labels[index],
                  style:  TextStyle(fontSize: 12, color: Colors.black),
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
    ),
    borderData: FlBorderData(show: false),
    gridData: FlGridData(
      show: true,
      drawHorizontalLine: true,
      horizontalInterval: data.reduce((a, b) => a > b ? a : b) / 4,
    ),
    barTouchData: BarTouchData(
      enabled: false, // Completely disable tooltips and touch interactions
    ),
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
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '₱${value.toStringAsFixed(0)}', // Display amount with peso symbol
                style: const TextStyle(fontSize: 10, color: Colors.black),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: 1, // Show labels for every data point
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < labels.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  labels[index],
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                ),
              );
            }
            return const Text('');
          },
        ),
      ),
    ),
    borderData: FlBorderData(show: false), // Remove unnecessary borders
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false, // Hide vertical grid lines
      horizontalInterval: _calculateInterval(data), // Space out horizontal lines
      getDrawingHorizontalLine: (value) => FlLine(
        color: Colors.grey.shade300,
        strokeWidth: 1,
      ),
    ),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (spots) => spots.map((spot) {
          final index = spot.x.toInt();
          return LineTooltipItem(
            '${labels[index]}: ₱${spot.y.toStringAsFixed(2)}',
            const TextStyle(color: Colors.white, fontSize: 12),
          );
        }).toList(),
      ),
    ),
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

List<PieChartSectionData> _buildPieChartSections(List<double> data, List<String> labels) {
  final total = data.reduce((a, b) => a + b);
  return List.generate(data.length, (index) {
    final percentage = ((data[index] / total) * 100).toStringAsFixed(1);
    return PieChartSectionData(
      color: _getColor(index),
      value: data[index],
      title: labels[index],
      radius: 60, // Adjusted for better spacing
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: _buildBadge(labels[index], data[index], percentage),
      badgePositionPercentageOffset: 1.2, // Positions the badge outside the chart
    );
  });
}

/// Builds a badge widget for each pie chart section.
Widget _buildBadge(String label, double value, String percentage) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '$percentage%',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      // Text(
      //   label,
      //   style: const TextStyle(
      //     fontSize: 10,
      //     color: Colors.black,
      //   ),
      // ),
      Gap(4),
      Container(
        decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(8)

        ),
        padding: EdgeInsets.all(2),
        child: Text(
          '₱ ${formatNumber(value)}',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

double _calculateInterval(List<double> data) {
  if (data.isEmpty) return 1;
  final maxY = data.reduce((a, b) => a > b ? a : b);
  return (maxY / 4).ceilToDouble(); // Divide into 4 intervals
}


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
    // showingTooltipIndicators: [0],
    );
  });
}

/// Retrieves a color for the chart sections/bars.
/// Retrieves a color for the chart sections/bars.
Color _getColor(int index) {
  const List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.yellow,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.amber,
    Colors.deepPurple,
    Colors.deepOrange,
  ];

  // Wrap-around for indices greater than the available colors
  return colors[index % colors.length];
}

/// Builds groups for the bar chart.

}
