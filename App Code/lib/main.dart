import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/crypto_donation_page.dart';

void main() => runApp(const StarterApp());

class StarterApp extends StatefulWidget {
  const StarterApp({super.key});

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF4968D8);
    return MaterialApp(
      title: 'New App',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
      ),
      home: StarterHomePage(
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}

class StarterHomePage extends StatelessWidget {
  const StarterHomePage({super.key, required this.onThemeModeChanged});

  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New App'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
            onPressed: () =>
                onThemeModeChanged(isDark ? ThemeMode.light : ThemeMode.dark),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.rocket_launch_outlined,
                    size: 36,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Your app starts here',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Replace this starter screen with your app. The theme toggle '
                    'and optional donation page are ready to customize.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.volunteer_activism_outlined),
              title: const Text('Support development'),
              subtitle: const Text('View optional donation addresses'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openDonationPage(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDonationPage(BuildContext context) async {
    try {
      final json = await rootBundle.loadString('assets/donation_wallets.json');
      final data = jsonDecode(json) as Map<String, dynamic>;
      final entries = data['donations'] as List<dynamic>;
      final wallets = entries
          .map((entry) {
            final wallet = entry as Map<String, dynamic>;
            return DonationWallet(
              currency: wallet['currency'] as String,
              network: wallet['network'] as String,
              address: wallet['address'] as String,
            );
          })
          .toList(growable: false);

      if (!context.mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => CryptoDonationPage(wallets: wallets),
        ),
      );
    } on Object catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load donation addresses: $error')),
      );
    }
  }
}
