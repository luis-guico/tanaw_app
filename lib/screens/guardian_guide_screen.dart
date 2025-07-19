import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanaw_app/models/faq_item.dart';
import 'package:tanaw_app/state/guardian_mode_state.dart';

class GuardianGuideScreen extends StatefulWidget {
  const GuardianGuideScreen({super.key});

  @override
  GuardianGuideScreenState createState() => GuardianGuideScreenState();
}

class GuardianGuideScreenState extends State<GuardianGuideScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int? _helpfulIndex;
  final List<String> _categories = [
    'All',
    'Getting Started',
    'Monitoring',
    'Notifications',
    'Modes',
    'Account & Settings',
    'Troubleshooting'
  ];

  List<FaqItem> get _filteredFaqItems {
    if (_searchQuery.isNotEmpty) {
      return faqItems
          .where((item) =>
              item.question.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_selectedCategory == 'All') {
      return faqItems;
    }
    return faqItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isGuardianMode =
        Provider.of<GuardianModeState>(context).isGuardianModeEnabled;
    final Color backgroundColor =
        isGuardianMode ? const Color(0xFF102A43) : Colors.white;
    final Color textColor = isGuardianMode ? Colors.white : Colors.black87;
    final Color accentColor =
        isGuardianMode ? Colors.cyanAccent : const Color(0xFF153A5B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text('Help & Support', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(isGuardianMode, accentColor),
          _buildFilterChips(isGuardianMode, accentColor),
          Expanded(
            child: _buildFaqList(isGuardianMode, accentColor, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isGuardianMode, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: TextStyle(color: isGuardianMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Search questions...',
          hintStyle:
              TextStyle(color: isGuardianMode ? Colors.white70 : Colors.grey),
          prefixIcon: Icon(Icons.search,
              color: isGuardianMode ? Colors.white70 : Colors.grey),
          filled: true,
          fillColor: isGuardianMode
              ? const Color(0xFF1E4872)
              : Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isGuardianMode, Color accentColor) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                }
              },
              backgroundColor: isGuardianMode
                  ? const Color(0xFF1E4872)
                  : Colors.grey.shade200,
              selectedColor: accentColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? (isGuardianMode ? Colors.black : Colors.white)
                    : (isGuardianMode ? Colors.white70 : Colors.black87),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: isSelected ? accentColor : Colors.transparent),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFaqList(
      bool isGuardianMode, Color accentColor, Color textColor) {
    final items = _filteredFaqItems;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          color:
              isGuardianMode ? const Color(0xFF1E4872) : Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            iconColor: textColor,
            collapsedIconColor: textColor,
            title: Text(
              item.question,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 16),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.answer,
                      style: TextStyle(
                          color: textColor.withAlpha(204),
                          fontSize: 14,
                          height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Was this helpful?',
                            style: TextStyle(color: textColor.withAlpha(204))),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () => setState(() => _helpfulIndex = index),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _helpfulIndex == index ? accentColor : Colors.transparent,
                            foregroundColor: accentColor,
                            side: BorderSide(color: accentColor),
                          ),
                          child: const Text('Yes'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => setState(() => _helpfulIndex = index),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _helpfulIndex == index ? Colors.grey : Colors.transparent,
                            foregroundColor: Colors.grey,
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
} 