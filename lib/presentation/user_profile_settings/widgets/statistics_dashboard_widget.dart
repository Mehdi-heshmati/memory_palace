import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsDashboardWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const StatisticsDashboardWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    // Mock accuracy trend data
    final List<Map<String, dynamic>> accuracyTrend = [
      {"day": "شنبه", "accuracy": 85.0},
      {"day": "یکشنبه", "accuracy": 88.0},
      {"day": "دوشنبه", "accuracy": 82.0},
      {"day": "سه‌شنبه", "accuracy": 90.0},
      {"day": "چهارشنبه", "accuracy": 87.0},
      {"day": "پنج‌شنبه", "accuracy": 92.0},
      {"day": "جمعه", "accuracy": 89.0},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'آمار یادگیری',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Achievement Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      (userData["achievements"] as List).map((achievement) {
                    return _buildAchievementBadge(achievement as String);
                  }).toList(),
                ),

                SizedBox(height: 3.h),

                // Accuracy Trend Chart
                Text(
                  'روند دقت هفتگی',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 2.h),

                SizedBox(
                  width: double.infinity,
                  height: 30.h,
                  child: Semantics(
                    label: "نمودار روند دقت هفتگی",
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                );
                                if (value.toInt() >= 0 &&
                                    value.toInt() < accuracyTrend.length) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      accuracyTrend[value.toInt()]["day"]
                                          as String,
                                      style: style,
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                              reservedSize: 32,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        minX: 0,
                        maxX: (accuracyTrend.length - 1).toDouble(),
                        minY: 70,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: accuracyTrend.asMap().entries.map((entry) {
                              return FlSpot(
                                entry.key.toDouble(),
                                entry.value["accuracy"] as double,
                              );
                            }).toList(),
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary,
                                AppTheme.lightTheme.colorScheme.secondary,
                              ],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  strokeWidth: 2,
                                  strokeColor:
                                      AppTheme.lightTheme.colorScheme.surface,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Additional Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: 'calendar_today',
                        title: 'عضویت از',
                        value: userData["joinDate"] as String,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildStatCard(
                        icon: 'star',
                        title: 'بهترین دقت',
                        value: '${userData["accuracy"]}%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(String achievement) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.secondary,
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'emoji_events',
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            achievement,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
