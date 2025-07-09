import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/statistiche_provider.dart';

class SchermataStatistiche extends StatelessWidget {
  const SchermataStatistiche({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statisticheProvider = Provider.of<StatisticheProvider>(context);
    final totaleVinili = statisticheProvider.totaleVinili;
    final viniliPerCategoria = statisticheProvider.viniliPerCategoria;
    final viniliPiuVecchi = statisticheProvider.viniliPiuVecchi;
    final crescitaAnnuale = statisticheProvider.crescitaAnnuale;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(
              context: context,
              title: 'Vinili Totali',
              value: totaleVinili.toString(),
              icon: Icons.album,
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context: context,
              title: 'Distribuzione per Genere',
              child: SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections:
                        viniliPerCategoria.entries.map((e) {
                          final index = viniliPerCategoria.keys
                              .toList()
                              .indexOf(e.key);
                          final color =
                              Colors.primaries[index % Colors.primaries.length];
                          return PieChartSectionData(
                            value: e.value.toDouble(),
                            title: e.key,
                            color: color,
                            radius: 50,
                            titleStyle: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context: context,
              title: 'Vinili più Vecchi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: viniliPiuVecchi.map((v) => Text(v)).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context: context,
              title: 'Crescita Collezione nel Tempo',
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups:
                        crescitaAnnuale.entries.map((e) {
                          final index = crescitaAnnuale.keys.toList().indexOf(
                            e.key,
                          );
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.toDouble(),
                                color: Colors.deepPurple,
                              ),
                            ],
                          );
                        }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (index, _) {
                            final year =
                                crescitaAnnuale.keys.toList()[index.toInt()];
                            return Text(
                              year,
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          children: [
            Icon(icon, size: 36, color: theme.colorScheme.secondary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.headlineSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.labelLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
