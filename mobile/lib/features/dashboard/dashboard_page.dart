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
          'ASKUALA EXAM',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
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
              'Exam Marker',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fade().slideX(),
            const SizedBox(height: 8),
            const Text(
              'Select an action to continue',
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
                  title: 'Mark Exam',
                  subtitle: 'Scan OMR Sheet',
                  icon: Icons.center_focus_strong,
                  color: AskualaTheme.primaryColor,
                  delay: 300.ms,
                  onTap: () => Navigator.pushNamed(context, '/scan'),
                ),
                _buildBentoCard(
                  context,
                  title: 'Answer Key',
                  subtitle: 'Set Correct Answers',
                  icon: Icons.assignment_turned_in_outlined,
                  color: AskualaTheme.secondaryColor,
                  delay: 400.ms,
                  onTap: () {},
                ),
                _buildBentoCard(
                  context,
                  title: 'History',
                  subtitle: 'Past Gradings',
                  icon: Icons.history_edu,
                  color: Colors.orange,
                  delay: 500.ms,
                  onTap: () {},
                ),
                _buildBentoCard(
                  context,
                  title: 'Settings',
                  subtitle: 'App Preferences',
                  icon: Icons.settings_outlined,
                  color: Colors.blueGrey,
                  delay: 600.ms,
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Recent Marking Section
            Text(
              'Recent Marking',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fade(delay: 700.ms),
            
            const SizedBox(height: 16),
            
            _buildActivityItem(
              title: 'Final Exam - Grade 12',
              subtitle: '45 sheets marked',
              time: '2h ago',
              status: 'Completed',
            ).animate().fade(delay: 800.ms).slideY(begin: 0.1),
            
            _buildActivityItem(
              title: 'Physics Quiz',
              subtitle: '12 sheets marked',
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
