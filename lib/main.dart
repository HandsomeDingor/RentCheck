import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const App());
}

/// --------- Routing ----------
final _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/features', builder: (_, __) => const FeaturesPage()),
        GoRoute(path: '/pricing', builder: (_, __) => const PricingPage()),
        GoRoute(path: '/demo', builder: (_, __) => const DemoPage()),
      ],
    )
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inspection Demo',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
    );
  }
}

/// --------- Shell + Nav ----------
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('InspectionFlow'),
        actions: [
          _NavButton(label: 'Home', to: '/', active: loc == '/'),
          _NavButton(label: 'Features', to: '/features', active: loc.startsWith('/features')),
          _NavButton(label: 'Pricing', to: '/pricing', active: loc.startsWith('/pricing')),
          _NavButton(label: 'Demo', to: '/demo', active: loc.startsWith('/demo')),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () => context.go('/demo'),
            child: const Text('Try Demo'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: child,
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String to;
  final bool active;
  const _NavButton({required this.label, required this.to, required this.active});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(to),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          decoration: active ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: const [
          Text('© 2026 InspectionFlow (demo)'),
          Text('No storage • No login • Frontend-only'),
        ],
      ),
    );
  }
}

/// --------- Marketing Pages ----------
class PageFrame extends StatelessWidget {
  final Widget child;
  const PageFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _HeroCard(
                  title: 'Tenant-guided inspections, simplified.',
                  subtitle:
                      'A frontend-only Flutter Web demo that mimics an inspection workflow: guided steps, photos (local), notes, and a final report preview.',
                  ctaText: 'Start Demo',
                  onCta: () => context.go('/demo'),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _MockPreviewCard(),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text('What you can demo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _Chip('Step-by-step items'),
              _Chip('Condition rating'),
              _Chip('Notes'),
              _Chip('Local “photo” selection'),
              _Chip('Progress & submit'),
              _Chip('Report JSON preview'),
            ],
          ),
          const SizedBox(height: 28),
          _Section(
            title: 'How it works (demo)',
            child: Row(
              children: const [
                Expanded(child: _StepCard(n: '1', title: 'Select an inspection', desc: 'Open Demo and start a sample inspection.')),
                SizedBox(width: 12),
                Expanded(child: _StepCard(n: '2', title: 'Complete guided steps', desc: 'Rate condition, add notes, optionally pick a file.')),
                SizedBox(width: 12),
                Expanded(child: _StepCard(n: '3', title: 'Submit & preview report', desc: 'See a structured report output (JSON).')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback onCta;

  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, height: 1.1)),
            const SizedBox(height: 12),
            Text(subtitle, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(onPressed: onCta, child: Text(ctaText)),
                OutlinedButton(onPressed: () => context.go('/features'), child: const Text('View Features')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MockPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: const Center(
                child: Text('Inspection timeline mock\n(Frontend-only demo)', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Tip: This demo keeps everything in memory. Refreshing the page resets progress.',
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Features', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          SizedBox(height: 10),
          Text('A lightweight UI that demonstrates the workflow end-to-end (no backend).'),
          SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FeatureCard(title: 'Guided Steps', desc: 'One item at a time with clear instructions.'),
              _FeatureCard(title: 'Condition Rating', desc: 'Poor / Fair / Good selection per item.'),
              _FeatureCard(title: 'Notes', desc: 'Freeform notes captured per item.'),
              _FeatureCard(title: 'Local Photo Pick', desc: 'Pick a local file (demo stores filename only).'),
              _FeatureCard(title: 'Progress & Resume', desc: 'Move back/forward and keep state in memory.'),
              _FeatureCard(title: 'Report Preview', desc: 'Submit to see a structured report output.'),
            ],
          ),
        ],
      ),
    );
  }
}

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pricing', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const Text('Demo-only cards. Replace with real pricing later.'),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(child: _PriceCard(title: 'Grow', price: '\$0', bullets: ['Marketing site', 'Demo flow', 'No storage'])),
              SizedBox(width: 12),
              Expanded(child: _PriceCard(title: 'Accelerate', price: '\$—', bullets: ['Add auth', 'Add DB', 'Generate PDF report'])),
              SizedBox(width: 12),
              Expanded(child: _PriceCard(title: 'Enterprise', price: '\$—', bullets: ['Integrations', 'Work orders', 'Role-based access'])),
            ],
          ),
        ],
      ),
    );
  }
}

/// --------- Demo (No storage) ----------
enum Condition { poor, fair, good }

class DemoItem {
  final String id;
  final String area;
  final String title;
  final String instructions;
  final bool requirePhoto;

  DemoItem({
    required this.id,
    required this.area,
    required this.title,
    required this.instructions,
    required this.requirePhoto,
  });
}

class DemoResponse {
  Condition? condition;
  String notes = '';
  String? pickedFileName; // demo only
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final items = <DemoItem>[
    DemoItem(
      id: 'kitchen_sink',
      area: 'Kitchen',
      title: 'Sink & Faucet',
      instructions: 'Check for leaks, water pressure, and any stains or damage.',
      requirePhoto: true,
    ),
    DemoItem(
      id: 'bathroom_toilet',
      area: 'Bathroom',
      title: 'Toilet & Flush',
      instructions: 'Test flush, check stability, and look for cracks or leaks.',
      requirePhoto: true,
    ),
    DemoItem(
      id: 'living_walls',
      area: 'Living Room',
      title: 'Walls & Paint',
      instructions: 'Look for scratches, holes, stains, and general paint condition.',
      requirePhoto: false,
    ),
    DemoItem(
      id: 'bedroom_floor',
      area: 'Bedroom',
      title: 'Flooring',
      instructions: 'Check carpet/wood for stains, scratches, squeaks, or damage.',
      requirePhoto: true,
    ),
  ];

  late final Map<String, DemoResponse> responses = {
    for (final it in items) it.id: DemoResponse(),
  };

  int index = 0;
  bool submitted = false;

  DemoItem get current => items[index];

  double get progress => (index + 1) / items.length;

  int get completedCount {
    int c = 0;
    for (final it in items) {
      final r = responses[it.id]!;
      if (r.condition != null) c++;
    }
    return c;
  }

  void _prev() {
    if (index > 0) setState(() => index--);
  }

  void _next() {
    if (index < items.length - 1) setState(() => index++);
  }

  void _submit() {
    setState(() => submitted = true);
  }

  void _reset() {
    setState(() {
      for (final r in responses.values) {
        r.condition = null;
        r.notes = '';
        r.pickedFileName = null;
      }
      index = 0;
      submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Demo: Tenant Inspection Flow', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Progress: $completedCount / ${items.length} items rated'),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 18),

          if (!submitted) ...[
            _ItemCard(
              item: current,
              response: responses[current.id]!,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton(onPressed: index == 0 ? null : _prev, child: const Text('Previous')),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: index == items.length - 1 ? null : _next,
                  child: const Text('Next'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: completedCount == items.length ? _submit : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Submit'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              completedCount == items.length
                  ? 'All set. Submit to preview the report.'
                  : 'Rate all items to enable Submit.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ] else ...[
            _ReportCard(
              items: items,
              responses: responses,
              onReset: _reset,
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final DemoItem item;
  final DemoResponse response;
  final VoidCallback onChanged;

  const _ItemCard({required this.item, required this.response, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final notesController = TextEditingController(text: response.notes);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(item.area.toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                const SizedBox(width: 10),
                Expanded(child: Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.instructions),
            const SizedBox(height: 14),
            const Text('Condition', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: Condition.values.map((c) {
                final selected = response.condition == c;
                return ChoiceChip(
                  label: Text(_condLabel(c)),
                  selected: selected,
                  onSelected: (_) {
                    response.condition = c;
                    onChanged();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Optional notes about damage, cleanliness, or anything to flag.',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                response.notes = v;
                onChanged();
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text('Photo', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Text(item.requirePhoto ? '(recommended)' : '(optional)',
                    style: TextStyle(color: Theme.of(context).hintColor)),
              ],
            ),
            const SizedBox(height: 8),
            _FakeFilePicker(
              picked: response.pickedFileName,
              onPick: (name) {
                response.pickedFileName = name;
                onChanged();
              },
              onClear: () {
                response.pickedFileName = null;
                onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _condLabel(Condition c) {
    switch (c) {
      case Condition.poor:
        return 'Poor';
      case Condition.fair:
        return 'Fair';
      case Condition.good:
        return 'Good';
    }
  }
}

/// Web demo: we avoid real upload; just simulate picking a filename.
/// If you want real file pick later, we can add `file_picker` package.
class _FakeFilePicker extends StatelessWidget {
  final String? picked;
  final ValueChanged<String> onPick;
  final VoidCallback onClear;

  const _FakeFilePicker({required this.picked, required this.onPick, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilledButton.tonalIcon(
          onPressed: () {
            // Simulate: pick a "filename"
            final ts = DateTime.now().millisecondsSinceEpoch;
            onPick('photo_$ts.jpg');
          },
          icon: const Icon(Icons.photo_camera),
          label: Text(picked == null ? 'Add photo (demo)' : 'Replace (demo)'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            picked ?? 'No file selected',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (picked != null) ...[
          const SizedBox(width: 10),
          TextButton(onPressed: onClear, child: const Text('Clear')),
        ]
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final List<DemoItem> items;
  final Map<String, DemoResponse> responses;
  final VoidCallback onReset;

  const _ReportCard({required this.items, required this.responses, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final report = {
      "inspectionType": "move_out",
      "submittedAt": DateTime.now().toIso8601String(),
      "items": [
        for (final it in items)
          {
            "area": it.area,
            "title": it.title,
            "condition": _cond(responses[it.id]!.condition),
            "notes": responses[it.id]!.notes,
            "photo": responses[it.id]!.pickedFileName,
          }
      ]
    };

    final pretty = const JsonEncoder.withIndent('  ').convert(report);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Submitted!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('This is a frontend-only “report” preview (JSON).'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: SelectableText(
                pretty,
                style: const TextStyle(fontFamily: 'monospace', height: 1.35),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Start over'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copy manually from the JSON block (demo).')),
                  ),
                  child: const Text('Copy tip'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  static String _cond(Condition? c) {
    if (c == null) return 'unrated';
    switch (c) {
      case Condition.poor:
        return 'poor';
      case Condition.fair:
        return 'fair';
      case Condition.good:
        return 'good';
    }
  }
}

/// --------- Shared UI widgets ----------
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String desc;
  const _FeatureCard({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(desc),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> bullets;

  const _PriceCard({required this.title, required this.price, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...bullets.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(b)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String n;
  final String title;
  final String desc;
  const _StepCard({required this.n, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(child: Text(n)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(desc),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(text));
  }
}