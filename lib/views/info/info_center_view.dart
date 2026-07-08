import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../models/info_center_data.dart';
import '../../viewmodels/info_center_viewmodel.dart';
import '../../widgets/app_drawer.dart';

class InfoCenterView extends ConsumerStatefulWidget {
  const InfoCenterView({Key? key}) : super(key: key);

  @override
  ConsumerState<InfoCenterView> createState() => _InfoCenterViewState();
}

class _InfoCenterViewState extends ConsumerState<InfoCenterView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(infoCenterProvider);
    final notifier = ref.read(infoCenterProvider.notifier);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Knowledge Base'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadData(),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading Information Center...'),
                ],
              ),
            );
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppTheme.dangerColor),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => notifier.loadData(),
                      child: const Text('Retry Loading'),
                    )
                  ],
                ),
              ),
            );
          }

          if (state.data == null) {
            return const Center(child: Text('No data loaded.'));
          }

          final data = state.data!;
          final hasSearch = state.searchQuery.trim().isNotEmpty;

          return Column(
            children: [
              // Top Title and Search Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                color: theme.colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Information Center',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Understand terminology, flight reference data, weather guidelines, and system models.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Unified Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search Information',
                        hintText: 'Search airlines, airports, glossary, FAQs, weather...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  notifier.updateSearchQuery('');
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) {
                        notifier.updateSearchQuery(val);
                      },
                    ),
                  ],
                ),
              ),

              // Conditional Body: Tab View or Global Search Panel
              Expanded(
                child: hasSearch
                    ? _buildGlobalSearchResults(context, data, state.searchQuery)
                    : Column(
                        children: [
                          // Tab Bar
                          TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: theme.colorScheme.primary,
                            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
                            indicatorColor: theme.colorScheme.primary,
                            tabs: const [
                              Tab(text: 'System & ML'),
                              Tab(text: 'Weather Guide'),
                              Tab(text: 'Directory'),
                              Tab(text: 'FAQ & Glossary'),
                            ],
                          ),
                          
                          // Tab Body
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildSystemMlTab(context, data),
                                _buildWeatherGuideTab(context, data),
                                _buildDirectoryTab(context, data),
                                _buildFaqGlossaryTab(context, data),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- SEARCH RESULTS VIEW ---
  Widget _buildGlobalSearchResults(BuildContext context, InfoCenterData data, String query) {
    final theme = Theme.of(context);
    final q = query.toLowerCase().trim();

    // Perform sub-searches
    final matchedAirlines = data.airlines.where((a) =>
        a.code.toLowerCase().contains(q) ||
        a.name.toLowerCase().contains(q) ||
        a.country.toLowerCase().contains(q)).toList();

    final matchedAirports = data.airports.where((a) =>
        a.iata.toLowerCase().contains(q) ||
        a.name.toLowerCase().contains(q) ||
        a.city.toLowerCase().contains(q) ||
        a.country.toLowerCase().contains(q)).toList();

    final matchedWeather = data.weatherParameters.where((w) =>
        w.name.toLowerCase().contains(q) ||
        w.description.toLowerCase().contains(q) ||
        w.impact.toLowerCase().contains(q)).toList();

    final matchedFaqs = data.faq.where((f) =>
        f.question.toLowerCase().contains(q) ||
        f.answer.toLowerCase().contains(q)).toList();

    final matchedGlossary = data.glossary.where((g) =>
        g.term.toLowerCase().contains(q) ||
        g.definition.toLowerCase().contains(q)).toList();

    final totalResults = matchedAirlines.length +
        matchedAirports.length +
        matchedWeather.length +
        matchedFaqs.length +
        matchedGlossary.length;

    if (totalResults == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.15)),
              const SizedBox(height: 16),
              const Text(
                'No Search Results',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                'No items matched "$query". Try spelling differently.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(Icons.manage_search, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Found $totalResults match(es) for "$query"',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (matchedWeather.isNotEmpty) ...[
          _buildSearchCategoryHeader(theme, 'Weather Parameters', Icons.wb_cloudy),
          ...matchedWeather.map((w) => _buildWeatherCard(context, w)),
          const SizedBox(height: 16),
        ],

        if (matchedAirlines.isNotEmpty || matchedAirports.isNotEmpty) ...[
          _buildSearchCategoryHeader(theme, 'Directory References', Icons.badge_outlined),
          if (matchedAirlines.isNotEmpty)
            _buildAirlineTableCard(context, matchedAirlines),
          if (matchedAirports.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildAirportTableCard(context, matchedAirports),
          ],
          const SizedBox(height: 16),
        ],

        if (matchedFaqs.isNotEmpty) ...[
          _buildSearchCategoryHeader(theme, 'Frequently Asked Questions', Icons.question_answer_outlined),
          ...matchedFaqs.map((f) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  title: Text(f.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(f.answer, style: const TextStyle(height: 1.4)),
                    )
                  ],
                ),
              )),
          const SizedBox(height: 16),
        ],

        if (matchedGlossary.isNotEmpty) ...[
          _buildSearchCategoryHeader(theme, 'Glossary Terms', Icons.book_outlined),
          ...matchedGlossary.map((g) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ExpansionTile(
                  title: Text(g.term, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(g.definition, style: const TextStyle(height: 1.4)),
                    )
                  ],
                ),
              )),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildSearchCategoryHeader(ThemeData theme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: SYSTEM & ML ---
  Widget _buildSystemMlTab(BuildContext context, InfoCenterData data) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // About System Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('About Flight intelligence', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                Text(data.about.purpose, style: const TextStyle(fontSize: 14, height: 1.4)),
                const SizedBox(height: 12),
                Text(
                  'Why it matters:',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(data.about.importance, style: const TextStyle(fontSize: 14, height: 1.4)),
                const SizedBox(height: 12),
                Text(
                  'Model Logic:',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(data.about.mlUsage, style: const TextStyle(fontSize: 14, height: 1.4)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Data Sources Combined:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      ...data.about.dataSources.map((ds) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 14),
                                const SizedBox(width: 8),
                                Expanded(child: Text(ds, style: const TextStyle(fontSize: 12))),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Workflow diagram
        Text(
          'Prediction System Workflow',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildWorkflowDiagram(context, data.workflow),
        const SizedBox(height: 20),

        // Delay Classification
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.flight_land, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Delay Classification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                Text(data.classification.definition, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.dangerColor)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('On-Time', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.successColor)),
                          const SizedBox(height: 4),
                          Text(data.classification.onTime, style: const TextStyle(fontSize: 12, height: 1.3)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Delay', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.dangerColor)),
                          const SizedBox(height: 4),
                          Text(data.classification.delay, style: const TextStyle(fontSize: 12, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Prediction Output & Confidence Guide
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Prediction Result Interpretation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                _buildGuideRow(
                  context: context,
                  label: 'On-Time Prediction:',
                  text: data.predictionGuide.onTimeMeaning,
                  icon: Icons.check_circle,
                  color: AppTheme.successColor,
                ),
                const SizedBox(height: 12),
                _buildGuideRow(
                  context: context,
                  label: 'Delay Prediction:',
                  text: data.predictionGuide.delayMeaning,
                  icon: Icons.warning,
                  color: AppTheme.dangerColor,
                ),
                const SizedBox(height: 12),
                _buildGuideRow(
                  context: context,
                  label: 'Confidence Scores:',
                  text: data.predictionGuide.confidenceExpl,
                  icon: Icons.percent,
                  color: AppTheme.infoColor,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Machine Learning Overview
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Machine Learning Algorithms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                ...data.mlModels.map((model) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        ...model.advantages.map((adv) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.star, size: 16, color: theme.colorScheme.primary.withOpacity(0.7)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(adv, style: const TextStyle(fontSize: 13, height: 1.3))),
                                ],
                              ),
                            )),
                        const SizedBox(height: 16),
                      ],
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Feature Importance
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.leaderboard_outlined, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Feature Weight & Importance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                Text(data.featureImportance.intro, style: const TextStyle(fontSize: 14, height: 1.4)),
                const SizedBox(height: 16),
                ...data.featureImportance.topFeatures.map((tf) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              tf.feature,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tf.impact,
                              style: const TextStyle(fontSize: 13, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideRow({
    required BuildContext context,
    required String label,
    required String text,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.7), height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Horizontal / Vertical Workflow Visualization
  Widget _buildWorkflowDiagram(BuildContext context, List<WorkflowStep> steps) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      return Container(
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              return Icon(Icons.arrow_forward, color: theme.colorScheme.primary.withOpacity(0.6), size: 20);
            }
            final idx = i ~/ 2;
            final step = steps[idx];
            return Expanded(
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primary.withOpacity(0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          step.step,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    // Vertical diagram for mobile/narrow constraints
    return Column(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Icon(Icons.arrow_downward, color: theme.colorScheme.primary.withOpacity(0.6), size: 20),
          );
        }
        final idx = i ~/ 2;
        final step = steps[idx];
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: theme.colorScheme.primary.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    step.step,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(
                        step.desc,
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- TAB 2: WEATHER GUIDE ---
  Widget _buildWeatherGuideTab(BuildContext context, InfoCenterData data) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Weather Parameter Grid/List
        Text(
          'Weather Parameters',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...data.weatherParameters.map((w) => _buildWeatherCard(context, w)),
        const SizedBox(height: 24),

        // Weather Severity Table Matrixes
        Text(
          'Weather Severity Guidelines',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSeverityMatrix(context, 'Visibility Levels', data.weatherSeverity.visibility),
        const SizedBox(height: 16),
        _buildSeverityMatrix(context, 'Wind Speed Levels', data.weatherSeverity.windSpeed),
        const SizedBox(height: 16),
        _buildSeverityMatrix(context, 'Rainfall Intensity Levels', data.weatherSeverity.rain),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWeatherCard(BuildContext context, WeatherParam w) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  w.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    w.unit,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(w.description, style: const TextStyle(fontSize: 13, height: 1.35)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Operational Impact: ${w.impact}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityMatrix(BuildContext context, String title, List<SeverityBand> bands) {
    final theme = Theme.of(context);
    
    // Help select colors representing warning severity
    Color _getSeverityColor(String level) {
      switch (level.toLowerCase()) {
        case 'excellent':
        case 'calm':
        case 'no rain':
          return AppTheme.successColor;
        case 'good':
        case 'light':
          return Colors.teal;
        case 'moderate':
          return AppTheme.infoColor;
        case 'poor':
        case 'strong':
        case 'heavy rain':
          return AppTheme.warningColor;
        case 'critical':
        case 'very strong':
          return AppTheme.dangerColor;
        default:
          return theme.colorScheme.primary;
      }
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          ...bands.map((band) {
            final col = _getSeverityColor(band.level);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.04)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: col.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      band.level,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 100,
                    child: Text(
                      band.range,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      band.description,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- TAB 3: DIRECTORY ---
  Widget _buildDirectoryTab(BuildContext context, InfoCenterData data) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAirlineTableCard(context, data.airlines),
        const SizedBox(height: 20),
        _buildAirportTableCard(context, data.airports),
      ],
    );
  }

  Widget _buildAirlineTableCard(BuildContext context, List<AirlineRef> airlines) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            child: const Row(
              children: [
                Icon(Icons.airplanemode_active, size: 18),
                SizedBox(width: 8),
                Text('Airline Reference Directory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                constraints: BoxConstraints(minWidth: width - 32),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => theme.colorScheme.onSurface.withOpacity(0.02),
                  ),
                  headingRowHeight: 44,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 48,
                  columns: const [
                    DataColumn(label: Text('Code', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Airline Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Country', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: airlines.map((a) {
                    return DataRow(
                      cells: [
                        DataCell(Text(a.code, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(a.name)),
                        DataCell(Text(a.country)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportTableCard(BuildContext context, List<AirportRef> airports) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.onSurface.withOpacity(0.04),
            child: const Row(
              children: [
                Icon(Icons.local_airport, size: 18),
                SizedBox(width: 8),
                Text('Airport Location Directory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                constraints: BoxConstraints(minWidth: width - 32),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => theme.colorScheme.onSurface.withOpacity(0.02),
                  ),
                  headingRowHeight: 44,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 48,
                  columns: const [
                    DataColumn(label: Text('IATA', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Airport Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('City', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Country', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: airports.map((a) {
                    return DataRow(
                      cells: [
                        DataCell(Text(a.iata, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(a.name)),
                        DataCell(Text(a.city)),
                        DataCell(Text(a.country)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: FAQ & TERMS ---
  Widget _buildFaqGlossaryTab(BuildContext context, InfoCenterData data) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // FAQs Accordion
        Text(
          'Frequently Asked Questions',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...data.faq.map((f) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ExpansionTile(
                title: Text(
                  f.question,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      f.answer,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  )
                ],
              ),
            )),
        const SizedBox(height: 24),

        // Glossary Alphabetical Accordions
        Text(
          'Aviation Glossary Terms',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...data.glossary.map((g) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ExpansionTile(
                title: Text(
                  g.term,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      g.definition,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
