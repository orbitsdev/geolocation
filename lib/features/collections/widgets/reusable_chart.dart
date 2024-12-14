// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocation/core/theme/palette.dart';
// import 'package:gap/gap.dart';
// import 'package:geolocation/features/collections/model/collection_item.dart';

// class ReusableChart extends StatelessWidget {
//   final String chartType; // Type of chart ('Pie Chart', 'Bar Chart', 'Line Chart')
//   final List<CollectionItem>? items;

//   const ReusableChart({
//     Key? key,
//     required this.chartType,
//     required this.items,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final data = items?.map((e) => e.amount?.toDouble() ?? 0.0).toList() ?? [];
//     final labels = items?.map((e) => e.label ?? 'No Label').toList() ?? [];

//     if (data.isEmpty || data.every((value) => value <= 0)) {
//       return const Center(child: Text('No data available for the chart.'));
//     }

//     switch (chartType) {
//       case 'Pie Chart':
//         return PieChart(
//           PieChartData(
//             sections: _buildPieChartSections(data, labels),
//             borderData: FlBorderData(show: false),
//             sectionsSpace: 4,
//             centerSpaceRadius: 50,
//             centerSpaceColor: Colors.white,
//           ),
//         );

//       case 'Bar Chart':
//         return BarChart(
//           BarChartData(
//             maxY: data.reduce((a, b) => a > b ? a : b) * 1.1,
//             barGroups: _buildBarChartGroups(data),
//             titlesData: _buildBarTitles(labels),
//             borderData: FlBorderData(show: false),
//             gridData: FlGridData(
//               show: true,
//               drawHorizontalLine: true,
//               horizontalInterval: data.reduce((a, b) => a > b ? a : b) / 4,
//             ),
//           ),
//         );

//       case 'Line Chart':
//         return LineChart(
//           LineChartData(
//             lineBarsData: _buildLineChartData(data),
//             titlesData: _buildLineTitles(labels),
//             borderData: FlBorderData(show: false),
//             gridData: FlGridData(
//               show: true,
//               drawVerticalLine: false,
//               horizontalInterval: _calculateInterval(data),
//               getDrawingHorizontalLine: (value) => FlLine(
//                 color: Colors.grey.shade300,
//                 strokeWidth: 1,
//               ),
//             ),
//           ),
//         );

//       default:
//         return const Center(child: Text('Invalid chart type.'));
//     }
//   }

//   // Pie chart sections
//   List<PieChartSectionData> _buildPieChartSections(List<double> data, List<String> labels) {
//     final total = data.reduce((a, b) => a + b);
//     return List.generate(data.length, (index) {
//       final percentage = ((data[index] / total) * 100).toStringAsFixed(1);
//       return PieChartSectionData(
//         color: _getColor(index),
//         value: data[index],
//         title: labels[index],
//         radius: 60,
//         titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
//         badgeWidget: _buildBadge(labels[index], data[index], percentage),
//         badgePositionPercentageOffset: 1.2,
//       );
//     });
//   }

//   // Badge for pie chart sections
//   Widget _buildBadge(String label, double value, String percentage) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           '$percentage%',
//           style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         const Gap(4),
//         Container(
//           decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(8)),
//           padding: const EdgeInsets.all(2),
//           child: Text(
//             '₱ ${value.toStringAsFixed(2)}',
//             style: const TextStyle(fontSize: 10, color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }

//   // Bar chart groups
//   List<BarChartGroupData> _buildBarChartGroups(List<double> data) {
//     return List.generate(data.length, (i) {
//       return BarChartGroupData(
//         x: i,
//         barRods: [
//           BarChartRodData(
//             toY: data[i],
//             color: _getColor(i),
//             width: 20,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ],
//       );
//     });
//   }

//   // Titles for bar chart
//   FlTitlesData _buildBarTitles(List<String> labels) {
//     return FlTitlesData(
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40,
//           getTitlesWidget: (value, meta) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: Text(
//                 '₱${value.toStringAsFixed(0)}',
//                 style:  TextStyle(fontSize: 10, color: Palette.PRIMARY),
//               ),
//             );
//           },
//         ),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           getTitlesWidget: (value, meta) {
//             final index = value.toInt();
//             if (index < labels.length) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   labels[index],
//                   style: const TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//               );
//             }
//             return const Text('');
//           },
//         ),
//       ),
//     );
//   }

//   // Line chart data
//   List<LineChartBarData> _buildLineChartData(List<double> data) {
//     return [
//       LineChartBarData(
//         spots: List.generate(
//           data.length,
//           (index) => FlSpot(index.toDouble(), data[index]),
//         ),
//         isCurved: true,
//         color: Colors.blue,
//         barWidth: 3,
//         isStrokeCapRound: true,
//         belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
//         dotData: FlDotData(show: true),
//       ),
//     ];
//   }

//   // Titles for line chart
//   FlTitlesData _buildLineTitles(List<String> labels) {
//     return FlTitlesData(
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40,
//           getTitlesWidget: (value, meta) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child: Text(
//                 '₱${value.toStringAsFixed(0)}',
//                 style: const TextStyle(fontSize: 10, color: Colors.black),
//               ),
//             );
//           },
//         ),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 40,
//           interval: 1,
//           getTitlesWidget: (value, meta) {
//             final index = value.toInt();
//             if (index >= 0 && index < labels.length) {
//               return Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   labels[index],
//                   style: const TextStyle(fontSize: 12, color: Colors.black),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               );
//             }
//             return const Text('');
//           },
//         ),
//       ),
//     );
//   }

//   // Calculates interval for grid lines
//   double _calculateInterval(List<double> data) {
//     if (data.isEmpty) return 1;
//     final maxY = data.reduce((a, b) => a > b ? a : b);
//     return (maxY / 4).ceilToDouble();
//   }

//   // Gets a color for chart sections
//   Color _getColor(int index) {
//     const colors = [
//       Colors.green,
//       Colors.blue,
//       Colors.orange,
//       Colors.red,
//       Colors.purple,
//       Colors.teal,
//       Colors.pink,
//       Colors.yellow,
//     ];
//     return colors[index % colors.length];
//   }
// }


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/model/collection_item.dart';

class ReusableChart extends StatelessWidget {
  final String chartType; // Type of chart ('Pie Chart', 'Bar Chart', 'Line Chart')
  final List<CollectionItem>? items;

  const ReusableChart({
    Key? key,
    required this.chartType,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = items?.map((e) => e.amount?.toDouble() ?? 0.0).toList() ?? [];
    final labels = items?.map((e) => e.label ?? 'No Label').toList() ?? [];

    if (data.isEmpty || data.every((value) => value <= 0)) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_chart_outlined, color: Colors.grey, size: 48),
            const Gap(8),
            Text(
              'No data available for the chart.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Gap(4),
            Text(
              'Please add items to visualize data.',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    switch (chartType) {
      case 'Pie Chart':
        return PieChart(
          PieChartData(
            sections: _buildPieChartSections(data, labels),
            borderData: FlBorderData(show: false),
            sectionsSpace: 4,
            centerSpaceRadius: MediaQuery.of(context).size.width * 0.2,
            centerSpaceColor: Colors.white,
          ),
        );

      case 'Bar Chart':
        return BarChart(
          BarChartData(
            maxY: data.reduce((a, b) => a > b ? a : b) * 1.1,
            barGroups: _buildBarChartGroups(data),
            titlesData: _buildBarTitles(labels),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              horizontalInterval: data.reduce((a, b) => a > b ? a : b) / 4,
            ),
          ),
        );

      case 'Line Chart':
        return LineChart(
          LineChartData(
            lineBarsData: _buildLineChartData(data),
            titlesData: _buildLineTitles(labels),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _calculateInterval(data),
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
              ),
            ),
          ),
        );

      default:
        return const Center(child: Text('Invalid chart type.'));
    }
  }

  List<PieChartSectionData> _buildPieChartSections(List<double> data, List<String> labels) {
    final total = data.reduce((a, b) => a + b);
    return List.generate(data.length, (index) {
      final percentage = ((data[index] / total) * 100).toStringAsFixed(1);
      return PieChartSectionData(
        color: _getColor(index),
        value: data[index],
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: _buildBadge(labels[index], data[index], percentage),
        badgePositionPercentageOffset: 1.2,
      );
    });
  }

  Widget _buildBadge(String label, double value, String percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.PRIMARY, Palette.GREEN2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '₱${value.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
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
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  FlTitlesData _buildBarTitles(List<String> labels) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '₱${value.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 10, color: Palette.PRIMARY),
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
                padding:  EdgeInsets.only(top: 4.0),
                child: Text(
                  labels[index],
                  style:  TextStyle(fontSize: 12, color: Colors.black),
                )
              );
            }
            return const Text('');
          },
        ),
      ),
    );
  }

  List<LineChartBarData> _buildLineChartData(List<double> data) {
    return [
      LineChartBarData(
        spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index])),
        isCurved: true,
        color: Colors.blue,
        barWidth: 3,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
        dotData: FlDotData(show: true),
      ),
    ];
  }

  FlTitlesData _buildLineTitles(List<String> labels) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                '₱${value.toStringAsFixed(0)}',
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
          interval: 1,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < labels.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  labels[index],
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                )
              );
            }
            return const Text('');
          },
        ),
      ),
    );
  }

  double _calculateInterval(List<double> data) {
    if (data.isEmpty) return 1;
    final maxY = data.reduce((a, b) => a > b ? a : b);
    return (maxY / 4).ceilToDouble();
  }

  Color _getColor(int index) {
    const colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.yellow,
    ];
    return colors[index % colors.length];
  }
}
