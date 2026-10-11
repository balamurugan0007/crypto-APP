// lib/widgets/price_chart_widget.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PriceChartWidget extends StatelessWidget {
  final List<List<dynamic>> chartData;
  final bool isPositive;

  const PriceChartWidget({
    super.key,
    required this.chartData,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return const Center(
        child: Text('No chart data', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final lineColor = isPositive ? AppColors.green : AppColors.red;

    
    final spots = <FlSpot>[];
    for (int i = 0; i < chartData.length; i++) {
      final price = (chartData[i][1] as num).toDouble();
      spots.add(FlSpot(i.toDouble(), price));
    }

    
    double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;
    minY = minY - padding;
    maxY = maxY + padding;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppColors.border,
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(
          show: false, 
        ),
        borderData: FlBorderData(show: false),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: lineColor,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  lineColor.withValues(alpha: 0.3),
                  lineColor.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppColors.cardBg2,
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      '\$${s.y.toStringAsFixed(2)}',
                      const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
