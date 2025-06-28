import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/yoga_meditation_provider.dart';
import '../../prakriti/providers/prakriti_provider.dart';
import 'meditation_detail_screen.dart';

class MeditationListScreen extends StatefulWidget {
  const MeditationListScreen({super.key});

  @override
  State<MeditationListScreen> createState() => _MeditationListScreenState();
}

class _MeditationListScreenState extends State<MeditationListScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search meditations...',
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
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Vata'),
                      _buildFilterChip('Pitta'),
                      _buildFilterChip('Kapha'),
                      _buildFilterChip('Breathing'),
                      _buildFilterChip('Mantra'),
                      _buildFilterChip('Visualization'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer2<YogaMeditationProvider, PrakritiProvider>(
              builder: (context, meditationProvider, prakritiProvider, child) {
                final dominantDosha = prakritiProvider.hasCompletedAssessment
                    ? prakritiProvider.dominantDosha
                    : '';
                
                List<Map<String, dynamic>> meditations = [];
                
                // Get meditations based on filter
                if (_selectedFilter == 'All') {
                  meditations = [
                    ...meditationProvider.getMeditationsForDosha('Vata'),
                    ...meditationProvider.getMeditationsForDosha('Pitta'),
                    ...meditationProvider.getMeditationsForDosha('Kapha'),
                  ];
                } else if (_selectedFilter == 'Vata' || 
                           _selectedFilter == 'Pitta' || 
                           _selectedFilter == 'Kapha') {
                  meditations = meditationProvider.getMeditationsForDosha(_selectedFilter);
                } else {
                  // Filter by type
                  meditations = [
                    ...meditationProvider.getMeditationsForDosha('Vata'),
                    ...meditationProvider.getMeditationsForDosha('Pitta'),
                    ...meditationProvider.getMeditationsForDosha('Kapha'),
                  ].where((meditation) => 
                    meditation['type']?.toLowerCase() == _selectedFilter.toLowerCase()
                  ).toList();
                }
                
                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  meditations = meditations.where((meditation) {
                    return meditation['name'].toLowerCase().contains(query) ||
                        meditation['description'].toLowerCase().contains(query) ||
                        (meditation['benefits'] as List).any((benefit) =>
                            benefit.toLowerCase().contains(query));
                  }).toList();
                }
                
                if (meditations.isEmpty) {
                  return const Center(
                    child: Text('No meditations found matching your search.'),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meditations.length,
                  itemBuilder: (context, index) {
                    final meditation = meditations[index];
                    return _buildMeditationCard(meditation, meditationProvider, dominantDosha);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? label : 'All';
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
        checkmarkColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
  
  Widget _buildMeditationCard(Map<String, dynamic> meditation, YogaMeditationProvider provider, String userDosha) {
    final isFavorite = provider.favoriteMeditations.contains(meditation['id']);
    final isRecommended = userDosha.isNotEmpty &&
        meditation['id'].toString().startsWith(userDosha.substring(0, 1).toLowerCase());
    
    // Get SVG asset path
    String svgAsset = _getSvgForMeditation(meditation['id']);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Use GoRouter for consistent navigation
          context.go('/meditation/${meditation['id']}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SVG image for meditation
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: svgAsset.isNotEmpty
                        ? SvgPicture.asset(
                            'assets/illustrations/yoga/$svgAsset',
                            height: 120,
                            placeholderBuilder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(),
                            ),
                          )
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
                if (isRecommended)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
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
                          meditation['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (isFavorite) {
                            provider.removeMeditationFromFavorites(meditation['id']);
                          } else {
                            provider.addMeditationToFavorites(meditation['id']);
                          }
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meditation['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: AppTheme.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        meditation['duration'],
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 16),
                      if (meditation['type'] != null) ...[  
                        const Icon(Icons.category, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          meditation['type'],
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to get SVG asset path for a meditation ID
  String _getSvgForMeditation(String meditationId) {
    if (meditationId.startsWith('v_')) return 'i1.svg';
    else if (meditationId.startsWith('p_')) return 'i2.svg';
    else if (meditationId.startsWith('k_')) return 'i3.svg';
    return 'i${(meditationId.hashCode % 5) + 1}.svg';
  }
}