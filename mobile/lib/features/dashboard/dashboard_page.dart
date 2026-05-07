import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AskualaTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'AUTOMARK AI',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AskualaTheme.primaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Teacher 👋',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fade().slideX(),
            const SizedBox(height: 8),
            const Text(
              'What would you like to do today?',
              style: TextStyle(color: AskualaTheme.mutedTextColor),
            ).animate().fade(delay: 200.ms),
            
            const SizedBox(height: 32),
            
            // Bento Grid Layout
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildBentoCard(
                  context,
                  title: 'Quick Scan',
                  subtitle: 'Scan OMR Sheet',
                  icon: Icons.qr_code_scanner,
                  color: AskualaTheme.primaryColor,
                  delay: 300.ms,
                  onTap: () => Navigator.pushNamed(context, '/scan'),
                ),
                _buildBentoCard(
                  context,
                  title: 'Answer Keys',
                  subtitle: 'Manage Keys',
                  icon: Icons.key_outlined,
                  color: AskualaTheme.secondaryColor,
                  delay: 400.ms,
                  onTap: () {},
                ),
                _buildBentoCard(
                  context,
                  title: 'Results',
                  subtitle: 'View Gradings',
                  icon: Icons.bar_chart_rounded,
                  color: Colors.orange,
                  delay: 500.ms,
                  onTap: () {},
                ),
                _buildBentoCard(
                  context,
                  title: 'History',
                  subtitle: 'Past Scans',
                  icon: Icons.history,
                  color: Colors.purple,
                  delay: 600.ms,
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ).animate().fade(delay: 700.ms),
            
            const SizedBox(height: 16),
            
            _buildActivityItem(
              title: 'Physics Midterm - Sec A',
              subtitle: '45 sheets processed',
              time: '2h ago',
              status: 'Completed',
            ).animate().fade(delay: 800.ms).slideY(begin: 0.1),
            
            _buildActivityItem(
              title: 'Math Quiz #3',
              subtitle: '12 sheets processed',
              time: '5h ago',
              status: 'Completed',
            ).animate().fade(delay: 900.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Duration delay,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AskualaTheme.mutedTextColor,
              ),
            ),
          ],
        ),
      ).animate().fade(delay: delay).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AskualaTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description_outlined, color: AskualaTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: AskualaTheme.mutedTextColor),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 10, color: AskualaTheme.mutedTextColor),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AskualaTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AskualaTheme.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
