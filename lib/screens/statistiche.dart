import 'package:flutter/material.dart';

class SchermataStatistiche extends StatelessWidget {
  const SchermataStatistiche({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      /*appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Statistiche',
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        elevation: 2,
      ),*/
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(
              context: context,
              title: 'Vinili Totali',
              value: '128',
              icon: Icons.album,
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              context: context,
              title: 'Categorie',
              value: '12',
              icon: Icons.category,
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context: context,
              title: 'Vinili per Categoria',
              child: const SizedBox(
                height: 200,
                child: Placeholder(), // TODO: sostituire con grafico
              ),
            ),
            const SizedBox(height: 16),
            _buildChartCard(
              context: context,
              title: 'Aggiunti nell\'ultimo mese',
              child: const SizedBox(
                height: 200,
                child: Placeholder(), // TODO: sostituire con grafico
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                Text(
                  title,
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall,
                ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
