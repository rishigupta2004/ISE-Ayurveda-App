import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/remedies_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurvedic Remedies'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Vata'),
            Tab(text: 'Pitta'),
            Tab(text: 'Kapha'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search remedies or conditions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer2<RemediesProvider, PrakritiProvider>(
              builder: (context, remediesProvider, prakritiProvider, child) {
                final dominantDosha = prakritiProvider.hasCompletedAssessment
                    ? prakritiProvider.dominantDosha
                    : '';
                
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // All Remedies Tab
                    _buildRemediesList(
                      [...remediesProvider.getRemediesForDosha('Vata'),
                       ...remediesProvider.getRemediesForDosha('Pitta'),
                       ...remediesProvider.getRemediesForDosha('Kapha')],
                      remediesProvider,
                      dominantDosha,
                    ),
                    // Vata Remedies Tab
                    _buildRemediesList(
                      remediesProvider.getRemediesForDosha('Vata'),
                      remediesProvider,
                      dominantDosha,
                    ),
                    // Pitta Remedies Tab
                    _buildRemediesList(
                      remediesProvider.getRemediesForDosha('Pitta'),
                      remediesProvider,
                      dominantDosha,
                    ),
                    // Kapha Remedies Tab
                    _buildRemediesList(
                      remediesProvider.getRemediesForDosha('Kapha'),
                      remediesProvider,
                      dominantDosha,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediesList(
    List<Map<String, dynamic>> remedies,
    RemediesProvider provider,
    String userDosha,
  ) {
    // Filter remedies based on search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      remedies = remedies.where((remedy) {
        return remedy['name'].toLowerCase().contains(query) ||
            remedy['description'].toLowerCase().contains(query) ||
            (remedy['conditions'] as List).any((condition) =>
                condition.toLowerCase().contains(query));
      }).toList();
    }

    if (remedies.isEmpty) {
      return const Center(
        child: Text('No remedies found matching your search.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: remedies.length,
      itemBuilder: (context, index) {
        final remedy = remedies[index];
        final isRecommended = userDosha.isNotEmpty &&
            remedy['id'].toString().startsWith(userDosha.substring(0, 1).toLowerCase());

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: InkWell(
            onTap: () {
              _showRemedyDetails(remedy, provider);
            },
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for image
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              remedy['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              provider.isFavorite(remedy['id'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: provider.isFavorite(remedy['id'])
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () {
                              if (provider.isFavorite(remedy['id'])) {
                                provider.removeFromFavorites(remedy['id']);
                              } else {
                                provider.addToFavorites(remedy['id']);
                              }
                            },
                          ),
                        ],
                      ),
                      if (isRecommended)
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Recommended for your dosha',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        remedy['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (remedy['conditions'] as List).map((condition) {
                          return Chip(
                            label: Text(
                              condition,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.grey.shade200,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRemedyDetails(Map<String, dynamic> remedy, RemediesProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            remedy['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            provider.isFavorite(remedy['id'])
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: provider.isFavorite(remedy['id'])
                                ? Colors.red
                                : null,
                            size: 28,
                          ),
                          onPressed: () {
                            if (provider.isFavorite(remedy['id'])) {
                              provider.removeFromFavorites(remedy['id']);
                            } else {
                              provider.addToFavorites(remedy['id']);
                            }
                            setState(() {}); // Refresh UI
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Placeholder for image
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      remedy['description'],
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailSection('Ingredients', remedy['ingredients']),
                    const SizedBox(height: 16),
                    _buildDetailSection('Preparation', [remedy['preparation']]),
                    const SizedBox(height: 16),
                    _buildDetailSection('Dosage', [remedy['dosage']]),
                    const SizedBox(height: 16),
                    _buildDetailSection('Good For', remedy['conditions']),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}