import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/database/collections/z_reading_entity.dart';
import 'z_reading_repository.dart';

class ZReadingScreen extends ConsumerStatefulWidget {
  const ZReadingScreen({super.key});

  @override
  ConsumerState<ZReadingScreen> createState() => _ZReadingScreenState();
}

class _ZReadingScreenState extends ConsumerState<ZReadingScreen> {
  final _repository = ZReadingRepository();
  bool _isProcessing = false;

  Future<void> _handleCloseDay() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('CLOSE THE DAY?', style: GoogleFonts.fraunces(fontWeight: FontWeight.bold)),
        content: const Text('This will generate a mandatory Z-Reading report and lock today\'s sales transactions. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emerald),
            child: const Text('CONFIRM & CLOSE'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      final result = await _repository.generateZReading();
      setState(() => _isProcessing = false);

      if (result != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Z-Reading Generated Successfully'), backgroundColor: AppTheme.emerald),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No transactions found for today.'), backgroundColor: Colors.orange),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bone,
      appBar: AppBar(
        title: Text('END OF DAY (Z-READING)', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16)),
      ),
      body: Column(
        children: [
          // HEADER ACTION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Daily Closing", style: Theme.of(context).textTheme.headlineLarge),
                    Text("BIR mandated reset of daily sales counters", style: TextStyle(color: AppTheme.ink.withOpacity(0.5))),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _handleCloseDay,
                    icon: _isProcessing 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                        : const Icon(Icons.lock_clock_outlined),
                    label: const Text("CLOSE THE DAY"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.ink, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // HISTORY LIST
          Expanded(
            child: FutureBuilder<List<ZReadingEntity>>(
              future: _repository.getZReadingHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final logs = snapshot.data!;

                if (logs.isEmpty) {
                  return Center(
                    child: Text("No closing reports found.", style: GoogleFonts.spaceGrotesk(color: AppTheme.ink.withOpacity(0.3))),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(40),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _ZReadingLogCard(log: log);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ZReadingLogCard extends StatelessWidget {
  final ZReadingEntity log;
  const _ZReadingLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.ink.withOpacity(0.08), width: 1.5),
      ),
      child: Row(
        children: [
          _Stat(label: "DATE", value: DateFormat('MMM dd, yyyy').format(log.readingDate)),
          const Spacer(),
          _Stat(label: "RESET COUNTER", value: log.resetCounter.toString().padLeft(4, '0')),
          const Spacer(),
          _Stat(label: "TRANS COUNT", value: log.totalTransactionCount.toString()),
          const Spacer(),
          _Stat(label: "NET SALES", value: "₱${log.netSales.toStringAsFixed(2)}", isBold: true),
          const SizedBox(width: 48),
          Icon(
            log.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            color: log.isSynced ? AppTheme.emerald : Colors.orange,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _Stat({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.ink.withOpacity(0.4), letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: isBold ? FontWeight.w900 : FontWeight.bold)),
      ],
    );
  }
}
