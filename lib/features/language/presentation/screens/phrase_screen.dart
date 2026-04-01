import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class PhraseScreen extends StatefulWidget {
  const PhraseScreen({super.key});

  @override
  State<PhraseScreen> createState() => _PhraseScreenState();
}

class _PhraseScreenState extends State<PhraseScreen> {
  List<Map<String, dynamic>> _phrases = [];
  String _selectedCategory = 'all';

  static const _categories = [
    ('all', '전체'),
    ('greeting', '인사'),
    ('price_ask', '가격 묻기'),
    ('too_expensive', '가격 협상'),
    ('discount', '할인'),
    ('buy', '구매'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    final json = await rootBundle.loadString('assets/data/phrases.json');
    final list = jsonDecode(json) as List;
    setState(() {
      _phrases = list.cast<Map<String, dynamic>>();
    });
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 'all') return _phrases;
    return _phrases.where((p) => p['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('아랍어 회화')),
      body: Column(
        children: [
          _CategoryChips(),
          Expanded(
            child: _phrases.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _PhraseCard(phrase: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _CategoryChips() {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: _categories.map((c) {
          final selected = _selectedCategory == c.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(c.$2),
              selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = c.$1),
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected ? AppColors.primary : AppColors.onSurfaceLight,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PhraseCard extends StatelessWidget {
  final Map<String, dynamic> phrase;
  const _PhraseCard({required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    phrase['text_kr'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: AppColors.primary),
                  onPressed: () {}, // TODO: flutter_tts
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              phrase['text_ar'] ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'NotoSansArabic',
                color: AppColors.onSurface,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              phrase['romanized'] ?? '',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
