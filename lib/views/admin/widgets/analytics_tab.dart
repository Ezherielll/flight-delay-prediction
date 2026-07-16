import 'package:fl_chart/fl_chart.dart';
import 'package:flight_delay_predict/core/theme/theme.dart';
import 'package:flight_delay_predict/core/utils/analytics_utils.dart';
import 'package:flight_server_client/flight_server_client.dart';
import 'package:flutter/material.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({required this.predictions, super.key});

  final List<PredictionRecord> predictions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (predictions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  size: 52,
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Analytics Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Analytics will appear here once AMC users\nstart making predictions.',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final summary = AnalyticsUtils.computeSummary(predictions);
    final airlineData = AnalyticsUtils.delayByAirline(predictions);
    final trendData = AnalyticsUtils.dailyTrend(predictions);
    final confidenceData = AnalyticsUtils.confidenceDistribution(predictions);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Overview Banner ────────────────────────────────────────────────
          _buildOverviewBanner(context, summary),
          const SizedBox(height: 24),

          // ── KPI Cards 2x2 ──────────────────────────────────────────────────
          _buildKpiGrid(context, summary),
          const SizedBox(height: 28),

          // ── Daily Trend ────────────────────────────────────────────────────
          _buildSectionHeader(
            context,
            Icons.show_chart_rounded,
            theme.colorScheme.primary,
            'Prediction Trend',
            'Daily predictions over the last 7 days',
          ),
          const SizedBox(height: 12),
          _buildDailyTrendCard(context, trendData),
          const SizedBox(height: 28),

          // ── Airlines Bar Chart ─────────────────────────────────────────────
          _buildSectionHeader(
            context,
            Icons.bar_chart_rounded,
            const Color(0xFFFF7043),
            'Top Airlines',
            'Delay distribution for top 5 most active airlines',
          ),
          const SizedBox(height: 12),
          _buildAirlineChartCard(context, airlineData),
          const SizedBox(height: 28),

          // ── Confidence Donut ───────────────────────────────────────────────
          _buildSectionHeader(
            context,
            Icons.donut_large_rounded,
            AppTheme.warningColor,
            'Confidence Distribution',
            'AI model prediction confidence level breakdown',
          ),
          const SizedBox(height: 12),
          _buildConfidenceCard(context, confidenceData, summary.totalPredictions),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Overview Banner ────────────────────────────────────────────────────────

  Widget _buildOverviewBanner(BuildContext context, AnalyticsSummary summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final delayRate = summary.totalPredictions > 0 ? summary.delayRate : 0.0;
    final onTimeRate = 1.0 - delayRate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E3A5F), const Color(0xFF0F172A)]
              : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analytics Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.totalPredictions} total predictions recorded',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${summary.uniqueUsers} users',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Delay vs On-Time Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Row(
              children: [
                Flexible(
                  flex: (delayRate * 100).round().clamp(0, 100),
                  child: Container(height: 7, color: AppTheme.dangerColor),
                ),
                Flexible(
                  flex: (onTimeRate * 100).round().clamp(0, 100),
                  child: Container(height: 7, color: AppTheme.successColor.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBannerStat(AppTheme.dangerColor, '${(delayRate * 100).toStringAsFixed(1)}% Delayed'),
              _buildBannerStat(AppTheme.successColor, '${(onTimeRate * 100).toStringAsFixed(1)}% On-Time'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerStat(Color dotColor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── Section Header ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(BuildContext context, IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── KPI Cards ──────────────────────────────────────────────────────────────

  Widget _buildKpiGrid(BuildContext context, AnalyticsSummary summary) {
    final delayPercent = (summary.delayRate * 100).toStringAsFixed(1);
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(context, 'Total Predictions', summary.totalPredictions.toString(), 'all time', Icons.assessment_rounded, primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(context, "Today's Requests", summary.todayPredictions.toString(), 'requests today', Icons.today_rounded, const Color(0xFFFF7043)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(context, 'Delay Rate', '$delayPercent%', 'of all predictions', Icons.warning_amber_rounded, AppTheme.dangerColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKpiCard(context, 'Active Users', summary.uniqueUsers.toString(), 'unique users', Icons.people_rounded, AppTheme.successColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.22 : 0.1),
            color.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.3 : 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 14),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.45)),
          ),
        ],
      ),
    );
  }

  // ── Chart Card Wrapper ─────────────────────────────────────────────────────

  Widget _buildChartCard(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.08), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── Daily Trend Line Chart ─────────────────────────────────────────────────

  Widget _buildDailyTrendCard(BuildContext context, Map<String, Map<String, int>> data) {
    final theme = Theme.of(context);
    final keys = data.keys.toList();

    final delayedSpots = <FlSpot>[];
    final ontimeSpots = <FlSpot>[];
    var maxY = 4.0;

    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      final delayed = data[key]!['delayed']!.toDouble();
      final ontime = data[key]!['ontime']!.toDouble();
      delayedSpots.add(FlSpot(i.toDouble(), delayed));
      ontimeSpots.add(FlSpot(i.toDouble(), ontime));
      if (delayed > maxY) maxY = delayed;
      if (ontime > maxY) maxY = ontime;
    }
    maxY = (maxY * 1.25).ceilToDouble();

    return _buildChartCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLegendDot(AppTheme.dangerColor, 'Delayed'),
              const SizedBox(width: 16),
              _buildLegendDot(AppTheme.successColor, 'On-Time'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                    tooltipRoundedRadius: 10,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isDelayed = spot.barIndex == 0;
                        return LineTooltipItem(
                          '${spot.y.toInt()} ${isDelayed ? "Delayed" : "On-Time"}',
                          TextStyle(
                            color: isDelayed ? AppTheme.dangerColor : AppTheme.successColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < keys.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              keys[idx],
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: maxY <= 10 ? 1 : null,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max || value == meta.min) return const Text('');
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.45)),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  _buildLineBar(delayedSpots, AppTheme.dangerColor),
                  _buildLineBar(ontimeSpots, AppTheme.successColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLineBar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
          radius: 4,
          color: bar.color ?? color,
          strokeColor: Colors.white,
          strokeWidth: 1.5,
        ),
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  // ── Airline Bar Chart ──────────────────────────────────────────────────────

  Widget _buildAirlineChartCard(BuildContext context, Map<String, Map<String, int>> data) {
    final theme = Theme.of(context);

    final sortedAirlines = data.keys.toList()
      ..sort((a, b) {
        final totalA = data[a]!['delayed']! + data[a]!['ontime']!;
        final totalB = data[b]!['delayed']! + data[b]!['ontime']!;
        return totalB.compareTo(totalA);
      });

    final displayAirlines = sortedAirlines.take(5).toList();

    var maxY = 4.0;
    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < displayAirlines.length; i++) {
      final airline = displayAirlines[i];
      final delayed = data[airline]!['delayed']!.toDouble();
      final ontime = data[airline]!['ontime']!.toDouble();
      if (delayed > maxY) maxY = delayed;
      if (ontime > maxY) maxY = ontime;

      barGroups.add(BarChartGroupData(
        x: i,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: delayed,
            color: AppTheme.dangerColor,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
          BarChartRodData(
            toY: ontime,
            color: AppTheme.successColor,
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      ));
    }
    maxY = (maxY * 1.3).ceilToDouble();

    return _buildChartCard(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildLegendDot(AppTheme.dangerColor, 'Delayed'),
              const SizedBox(width: 16),
              _buildLegendDot(AppTheme.successColor, 'On-Time'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: displayAirlines.isEmpty
                ? Center(
                    child: Text(
                      'No airline data available',
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                          tooltipRoundedRadius: 10,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (groupIndex >= displayAirlines.length) return null;
                            final airline = displayAirlines[group.x];
                            final type = rodIndex == 0 ? 'Delayed' : 'On-Time';
                            final count = rod.toY.toInt();
                            return BarTooltipItem(
                              '$airline  ·  $type: $count',
                              TextStyle(
                                color: theme.colorScheme.onInverseSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      maxY: maxY,
                      groupsSpace: 20,
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(),
                        topTitles: const AxisTitles(),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: maxY <= 10 ? 1 : null,
                            getTitlesWidget: (value, meta) {
                              if (value == meta.max || value == meta.min) return const Text('');
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.45)),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx >= 0 && idx < displayAirlines.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    displayAirlines[idx],
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      barGroups: barGroups,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Confidence Donut Chart ─────────────────────────────────────────────────

  Widget _buildConfidenceCard(BuildContext context, Map<String, int> data, int total) {
    final theme = Theme.of(context);
    final highCount = data['High'] ?? 0;
    final medCount = data['Medium'] ?? 0;
    final lowCount = data['Low'] ?? 0;

    final highPct = total > 0 ? (highCount / total * 100).toStringAsFixed(1) : '0.0';
    final medPct = total > 0 ? (medCount / total * 100).toStringAsFixed(1) : '0.0';
    final lowPct = total > 0 ? (lowCount / total * 100).toStringAsFixed(1) : '0.0';

    return _buildChartCard(
      context,
      Row(
        children: [
          // Donut chart with center label
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 55,
                      sections: total == 0
                          ? [
                              PieChartSectionData(
                                value: 1,
                                title: '',
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                                radius: 36,
                              ),
                            ]
                          : [
                              PieChartSectionData(
                                value: highCount.toDouble(),
                                title: '$highPct%',
                                radius: 36,
                                color: AppTheme.successColor,
                                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: medCount.toDouble(),
                                title: '$medPct%',
                                radius: 36,
                                color: AppTheme.warningColor,
                                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: lowCount.toDouble(),
                                title: '$lowPct%',
                                radius: 36,
                                color: AppTheme.dangerColor,
                                titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                    ),
                  ),
                  // Center label
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toString(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Legend with values
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildConfidenceLegendRow(context, 'High Confidence', '$highCount', '$highPct%', AppTheme.successColor),
                const SizedBox(height: 14),
                _buildConfidenceLegendRow(context, 'Medium Confidence', '$medCount', '$medPct%', AppTheme.warningColor),
                const SizedBox(height: 14),
                _buildConfidenceLegendRow(context, 'Low Confidence', '$lowCount', '$lowPct%', AppTheme.dangerColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceLegendRow(BuildContext context, String label, String count, String pct, Color color) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(count, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
            Text(pct, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.45))),
          ],
        ),
      ],
    );
  }
}
