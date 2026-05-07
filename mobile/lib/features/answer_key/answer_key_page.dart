import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class AnswerKeyPage extends StatefulWidget {
  const AnswerKeyPage({super.key});

  @override
  State<AnswerKeyPage> createState() => _AnswerKeyPageState();
}

class _AnswerKeyPageState extends State<AnswerKeyPage> {
  String _examType = 'Mid-Term';
  int _questionCount = 20;
  double _totalMarks = 100.0;
  final Map<int, String> _answers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AskualaTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'SET ANSWER KEY',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exam Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsCard(),
                    const SizedBox(height: 32),
                    const Text(
                      'Correct Answers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildQuestionRow(index + 1),
                  childCount: _questionCount,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Answer Key Saved Successfully!'),
              backgroundColor: AskualaTheme.secondaryColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        label: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        backgroundColor: AskualaTheme.primaryColor,
      ).animate().scale(delay: 400.ms),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputField('Exam Name', _examType, (val) => setState(() => _examType = val)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(
                child: _buildNumberField('Questions', _questionCount, (val) => setState(() => _questionCount = val)),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade100),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField('Marks', _totalMarks.toInt(), (val) => setState(() => _totalMarks = val.toDouble())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AskualaTheme.mutedTextColor, fontSize: 12)),
        TextField(
          decoration: const InputDecoration(border: InputBorder.none, isDense: true),
          controller: TextEditingController(text: value),
          onSubmitted: onChanged,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildNumberField(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AskualaTheme.mutedTextColor, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            InkWell(
              onTap: () => onChanged(value > 1 ? value - 1 : 1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.remove, size: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            InkWell(
              onTap: () => onChanged(value + 1),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.add, size: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionRow(int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AskualaTheme.primaryColor.withOpacity(0.1),
            radius: 18,
            child: Text('$number', style: const TextStyle(color: AskualaTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['A', 'B', 'C', 'D'].map((option) {
                bool isSelected = _answers[number] == option;
                return InkWell(
                  onTap: () => setState(() => _answers[number] = option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AskualaTheme.primaryColor : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? AskualaTheme.primaryColor : Colors.grey.shade200),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (number * 50).ms).slideY(begin: 0.1, end: 0);
  }
}
