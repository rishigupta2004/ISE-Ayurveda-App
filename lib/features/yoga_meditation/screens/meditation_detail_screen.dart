import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import '../../../core/theme/app_theme.dart';
import '../providers/yoga_meditation_provider.dart';

class MeditationDetailScreen extends StatefulWidget {
  final String meditationId;
  
  const MeditationDetailScreen({super.key, required this.meditationId});

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  // Meditation session variables
  bool _isCountdownVisible = false;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;
  
  bool _isSessionInProgress = false;
  int _sessionTimeRemaining = 0;
  int _totalSessionTime = 0;
  Timer? _sessionTimer;
  Map<String, dynamic>? _currentMeditation;
  
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YogaMeditationProvider>(builder: (context, provider, child) {
      // Find the meditation with the matching ID
      Map<String, dynamic> meditation;
      
      // Check in Vata meditations
      meditation = provider.getMeditationsForDosha('Vata')
          .firstWhere((m) => m['id'] == widget.meditationId, orElse: () => {});
      
      // If not found, check in Pitta meditations
      if (meditation.isEmpty) {
        meditation = provider.getMeditationsForDosha('Pitta')
            .firstWhere((m) => m['id'] == widget.meditationId, orElse: () => {});
      }
      
      // If still not found, check in Kapha meditations
      if (meditation.isEmpty) {
        meditation = provider.getMeditationsForDosha('Kapha')
            .firstWhere((m) => m['id'] == widget.meditationId, orElse: () => {});
      }
      
      // If meditation is not found, show error
      if (meditation.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Meditation')),
          body: const Center(child: Text('Meditation not found')),
        );
      }
      
      final isFavorite = provider.favoriteMeditations.contains(meditation['id']);
      
      return Scaffold(
        body: Stack(
          children: [
            // Main content
            CustomScrollView(
              slivers: [
                // App bar with meditation image
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      child: Center(
                        child: _getSvgForMeditation(meditation['id']).isNotEmpty
                            ? SvgPicture.asset(
                                'assets/illustrations/yoga/${_getSvgForMeditation(meditation['id'])}',
                                height: 200,
                                placeholderBuilder: (BuildContext context) => Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : const Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          provider.removeMeditationFromFavorites(meditation['id']);
                        } else {
                          provider.addMeditationToFavorites(meditation['id']);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // TODO: Implement share functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share functionality coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
                
                // Meditation details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meditation name
                        Text(
                          meditation['name'],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        
                        // Duration
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 20, color: AppTheme.secondaryColor),
                            const SizedBox(width: 8),
                            Text(
                              meditation['duration'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (meditation['type'] != null) ...[  
                              const SizedBox(width: 24),
                              const Icon(Icons.category, size: 20, color: AppTheme.secondaryColor),
                              const SizedBox(width: 8),
                              Text(
                                meditation['type'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(meditation['description']),
                        const SizedBox(height: 24),
                        
                        // Benefits
                        _buildDetailSection('Benefits', meditation['benefits']),
                        
                        // Instructions
                        _buildDetailSection('Instructions', meditation['instructions']),
                        
                        const SizedBox(height: 32),
                        
                        // Start meditation button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _startMeditationSession(meditation),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Begin Meditation'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Countdown overlay
            if (_isCountdownVisible)
              _buildCountdownOverlay(),
            
            // Session in progress overlay
            if (_isSessionInProgress)
              _buildSessionOverlay(),
          ],
        ),
      );
    });
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
                  const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  // Start a meditation session
  void _startMeditationSession(Map<String, dynamic> meditation) {
    _currentMeditation = meditation;
    
    // Parse duration string to get seconds
    final durationString = meditation['duration'];
    final durationRegex = RegExp(r'(\d+)\s*(min|sec)');
    final match = durationRegex.firstMatch(durationString);
    
    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2);
      
      if (unit == 'min') {
        _totalSessionTime = value * 60;
      } else {
        _totalSessionTime = value;
      }
      
      _sessionTimeRemaining = _totalSessionTime;
      
      // Start countdown
      setState(() {
        _isCountdownVisible = true;
        _countdownSeconds = 5;
      });
      
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownSeconds > 1) {
            _countdownSeconds--;
          } else {
            _countdownTimer?.cancel();
            _isCountdownVisible = false;
            _startSessionTimer();
          }
        });
      });
    }
  }

  // Start the session timer
  void _startSessionTimer() {
    setState(() {
      _isSessionInProgress = true;
    });
    
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_sessionTimeRemaining > 1) {
          _sessionTimeRemaining--;
        } else {
          _sessionTimer?.cancel();
          _completeSession();
        }
      });
    });
  }

  // Complete the session
  void _completeSession() {
    setState(() {
      _isSessionInProgress = false;
    });
    
    // Record completion
    final provider = Provider.of<YogaMeditationProvider>(context, listen: false);
    provider.completeMeditationSession(_currentMeditation!['id']);
    
    // Show completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meditation Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.self_improvement, color: AppTheme.secondaryColor, size: 50),
            const SizedBox(height: 16),
            const Text('You completed your meditation session!'),
            const SizedBox(height: 8),
            Text(
              'Keep up the good work to maintain your streak of ${provider.streak} days!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Build the countdown overlay
  Widget _buildCountdownOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Prepare for Meditation',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryColor,
              ),
              child: Center(
                child: Text(
                  '$_countdownSeconds',
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the session overlay
  Widget _buildSessionOverlay() {
    final minutes = _sessionTimeRemaining ~/ 60;
    final seconds = _sessionTimeRemaining % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final progress = 1 - (_sessionTimeRemaining / _totalSessionTime);
    
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Column(
        children: [
          // Top bar with close button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _sessionTimer?.cancel();
                      setState(() {
                        _isSessionInProgress = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Meditation display
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Meditation name
                  Text(
                    _currentMeditation?['name'] ?? 'Meditation',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Meditation image
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _getSvgForMeditation(_currentMeditation?['id'] ?? '').isNotEmpty
                          ? SvgPicture.asset(
                              'assets/illustrations/yoga/${_getSvgForMeditation(_currentMeditation?['id'] ?? '')}',
                              height: 150,
                              placeholderBuilder: (BuildContext context) => Container(
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : const Icon(Icons.self_improvement, size: 100, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Breathing guidance
                  const Text(
                    'Breathe in... Breathe out...',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  
                  // Timer
                  Text(
                    timeString,
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade800,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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