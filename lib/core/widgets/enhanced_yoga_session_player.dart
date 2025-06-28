import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import 'vedic_components.dart';

class EnhancedYogaSessionPlayer extends StatefulWidget {
  final String title;
  final String duration;
  final String description;
  final String imageAsset;
  final List<String> instructions;
  final String difficulty; // Easy, Medium, Hard
  final List<String> benefits;
  final List<String> breathingGuide;
  final Map<String, dynamic>? chakraAlignment;
  final VoidCallback? onComplete;

  const EnhancedYogaSessionPlayer({
    super.key,
    required this.title,
    required this.duration,
    required this.description,
    required this.imageAsset,
    required this.instructions,
    this.difficulty = 'Medium',
    this.benefits = const [],
    this.breathingGuide = const [],
    this.chakraAlignment,
    this.onComplete,
  });

  @override
  State<EnhancedYogaSessionPlayer> createState() => _EnhancedYogaSessionPlayerState();
}

class _EnhancedYogaSessionPlayerState extends State<EnhancedYogaSessionPlayer> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 0;
  Timer? _timer;
  late TabController _tabController;
  bool _showBreathingGuide = false;
  int _breathingPhase = 0; // 0: inhale, 1: hold, 2: exhale
  Timer? _breathingTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Parse duration string (e.g., "15 min") to seconds
    final durationParts = widget.duration.split(' ');
    if (durationParts.length >= 2 && durationParts[1].startsWith('min')) {
      _totalSeconds = int.tryParse(durationParts[0]) ?? 0;
      _totalSeconds *= 60; // Convert to seconds
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathingTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
        if (widget.breathingGuide.isNotEmpty) {
          _startBreathingGuide();
        }
      } else {
        _timer?.cancel();
        _breathingTimer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds < _totalSeconds) {
          _currentSeconds++;
        } else {
          _timer?.cancel();
          _breathingTimer?.cancel();
          _isPlaying = false;
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      });
    });
  }

  void _startBreathingGuide() {
    _showBreathingGuide = true;
    _breathingPhase = 0;
    
    // Cycle through breathing phases: inhale (4s) -> hold (4s) -> exhale (4s)
    _breathingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _breathingPhase = (_breathingPhase + 1) % 3;
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _currentSeconds = 0;
      _isPlaying = false;
      _timer?.cancel();
      _breathingTimer?.cancel();
      _showBreathingGuide = false;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy': return Colors.green;
      case 'medium': return Colors.orange;
      case 'hard': return Colors.red;
      default: return Colors.orange;
    }
  }

  String _getBreathingText() {
    switch (_breathingPhase) {
      case 0: return 'Inhale';
      case 1: return 'Hold';
      case 2: return 'Exhale';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSeconds > 0 ? _currentSeconds / _totalSeconds : 0.0;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with difficulty badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  widget.imageAsset,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.difficulty,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Breathing guide overlay
              if (_showBreathingGuide && _isPlaying)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 4),
                        width: _breathingPhase == 1 ? 150 : 120,
                        height: _breathingPhase == 1 ? 150 : 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withOpacity(0.7),
                        ),
                        child: Center(
                          child: Text(
                            _getBreathingText(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and duration
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.duration,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                
                // Progress bar
                VedicProgressIndicator(value: progress),
                const SizedBox(height: 8),
                
                // Timer display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_currentSeconds)),
                    Text(_formatDuration(_totalSeconds)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Player controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: () {
                        setState(() {
                          _currentSeconds = (_currentSeconds - 10).clamp(0, _totalSeconds);
                        });
                      },
                    ),
                    FloatingActionButton(
                      onPressed: _togglePlayPause,
                      child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: () {
                        setState(() {
                          _currentSeconds = (_currentSeconds + 10).clamp(0, _totalSeconds);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tabs for Instructions, Benefits, and Chakra Alignment
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Instructions'),
                    Tab(text: 'Benefits'),
                    Tab(text: 'Chakra'),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Instructions Tab
                      _buildInstructionsTab(),
                      
                      // Benefits Tab
                      _buildBenefitsTab(),
                      
                      // Chakra Alignment Tab
                      _buildChakraTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsTab() {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: widget.instructions.asMap().entries.map((entry) {
        final index = entry.key;
        final instruction = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instruction,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBenefitsTab() {
    if (widget.benefits.isEmpty) {
      return const Center(
        child: Text('No benefits information available'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: widget.benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(benefit),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChakraTab() {
    if (widget.chakraAlignment == null) {
      return const Center(
        child: Text('No chakra alignment information available'),
      );
    }
    
    final chakraName = widget.chakraAlignment!['name'] as String;
    final chakraDescription = widget.chakraAlignment!['description'] as String;
    final chakraColor = _getChakraColor(chakraName);
    
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: chakraColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                chakraName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: chakraColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(chakraDescription),
        ],
      ),
    );
  }
  
  Color _getChakraColor(String chakraName) {
    switch (chakraName.toLowerCase()) {
      case 'muladhara': return AppTheme.muladharaColor;
      case 'svadhishthana': return AppTheme.svadhishthanaColor;
      case 'manipura': return AppTheme.manipuraColor;
      case 'anahata': return AppTheme.anahataColor;
      case 'vishuddha': return AppTheme.vishuddhaColor;
      case 'ajna': return AppTheme.ajnaColor;
      case 'sahasrara': return AppTheme.sahasraraColor;
      default: return AppTheme.chakraGold;
    }
  }
}

class EnhancedMeditationMusicPlayer extends StatefulWidget {
  final String title;
  final String duration;
  final String imageAsset;
  final String audioAsset;
  final String? chakraType;
  final String? description;
  final List<String> benefits;
  final Map<String, dynamic>? guidedMeditation;

  const EnhancedMeditationMusicPlayer({
    super.key,
    required this.title,
    required this.duration,
    required this.imageAsset,
    required this.audioAsset,
    this.chakraType,
    this.description,
    this.benefits = const [],
    this.guidedMeditation,
  });

  @override
  State<EnhancedMeditationMusicPlayer> createState() => _EnhancedMeditationMusicPlayerState();
}

class _EnhancedMeditationMusicPlayerState extends State<EnhancedMeditationMusicPlayer> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 300; // Default 5 minutes
  Timer? _timer;
  late TabController _tabController;
  bool _showGuidedText = false;
  int _currentGuidedIndex = 0;
  List<String> _guidedSteps = [];
  Timer? _guidedTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Parse duration string (e.g., "5:00")
    final durationParts = widget.duration.split(':');
    if (durationParts.length == 2) {
      final minutes = int.tryParse(durationParts[0]) ?? 0;
      final seconds = int.tryParse(durationParts[1]) ?? 0;
      _totalSeconds = (minutes * 60) + seconds;
    }
    
    // Initialize guided meditation steps if available
    if (widget.guidedMeditation != null) {
      _guidedSteps = List<String>.from(widget.guidedMeditation!['steps']);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _guidedTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
        if (_guidedSteps.isNotEmpty) {
          _startGuidedMeditation();
        }
      } else {
        _timer?.cancel();
        _guidedTimer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds < _totalSeconds) {
          _currentSeconds++;
        } else {
          _timer?.cancel();
          _guidedTimer?.cancel();
          _isPlaying = false;
        }
      });
    });
  }

  void _startGuidedMeditation() {
    _showGuidedText = true;
    _currentGuidedIndex = 0;
    
    // Show each guided step for 15 seconds
    _guidedTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        if (_currentGuidedIndex < _guidedSteps.length - 1) {
          _currentGuidedIndex++;
        } else {
          _guidedTimer?.cancel();
          _showGuidedText = false;
        }
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalSeconds > 0 ? _currentSeconds / _totalSeconds : 0.0;
    final chakraColor = widget.chakraType != null
        ? _getChakraColor(widget.chakraType!)
        : AppTheme.primaryColor;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image with overlay
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  widget.imageAsset,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              // Title overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Guided meditation overlay
              if (_showGuidedText && _isPlaying)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        _guidedSteps[_currentGuidedIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Player controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Description if available
                if (widget.description != null) ...[  
                  Text(
                    widget.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Audio visualization (simulated)
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      30,
                      (index) => Container(
                        width: 3,
                        height: (20 + (index % 5) * 5) * (_isPlaying ? 1.0 : 0.5),
                        decoration: BoxDecoration(
                          color: _isPlaying
                              ? chakraColor.withOpacity(0.5 + (index % 3) * 0.2)
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress and time
                VedicProgressIndicator(
                  value: progress,
                  color: chakraColor,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_currentSeconds)),
                    Text(_formatDuration(_totalSeconds)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Player controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        // Previous track functionality would go here
                      },
                    ),
                    FloatingActionButton(
                      onPressed: _togglePlayPause,
                      backgroundColor: chakraColor,
                      child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        // Next track functionality would go here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tabs for Benefits and Chakra Information
                TabBar(
                  controller: _tabController,
                  labelColor: chakraColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Benefits'),
                    Tab(text: 'Chakra Info'),
                  ],
                ),
                SizedBox(
                  height: 150,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Benefits Tab
                      _buildBenefitsTab(),
                      
                      // Chakra Info Tab
                      _buildChakraInfoTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsTab() {
    if (widget.benefits.isEmpty) {
      return const Center(
        child: Text('No benefits information available'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: widget.benefits.map((benefit) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.spa, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(benefit),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChakraInfoTab() {
    if (widget.chakraType == null) {
      return const Center(
        child: Text('No chakra information available'),
      );
    }
    
    final chakraInfo = _getChakraInfo(widget.chakraType!);
    final chakraColor = _getChakraColor(widget.chakraType!);
    
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: chakraColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.chakraType!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: chakraColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(chakraInfo),
        ],
      ),
    );
  }
  
  Color _getChakraColor(String chakraType) {
    switch (chakraType.toLowerCase()) {
      case 'muladhara': return AppTheme.muladharaColor;
      case 'svadhishthana': return AppTheme.svadhishthanaColor;
      case 'manipura': return AppTheme.manipuraColor;
      case 'anahata': return AppTheme.anahataColor;
      case 'vishuddha': return AppTheme.vishuddhaColor;
      case 'ajna': return AppTheme.ajnaColor;
      case 'sahasrara': return AppTheme.sahasraraColor;
      default: return AppTheme.chakraGold;
    }
  }
  
  String _getChakraInfo(String chakraType) {
    switch (chakraType.toLowerCase()) {
      case 'muladhara':
        return 'Root Chakra - Located at the base of the spine. Associated with stability, security, and basic needs.';
      case 'svadhishthana':
        return 'Sacral Chakra - Located below the navel. Associated with creativity, pleasure, and emotional balance.';
      case 'manipura':
        return 'Solar Plexus Chakra - Located in the stomach area. Associated with personal power, confidence, and self-esteem.';
      case 'anahata':
        return 'Heart Chakra - Located at the center of the chest. Associated with love, compassion, and harmony.';
      case 'vishuddha':
        return 'Throat Chakra - Located at the throat. Associated with communication, self-expression, and truth.';
      case 'ajna':
        return 'Third Eye Chakra - Located between the eyebrows. Associated with intuition, imagination, and wisdom.';
      case 'sahasrara':
        return 'Crown Chakra - Located at the top of the head. Associated with spiritual connection, consciousness, and enlightenment.';
      default:
        return 'Information not available for this chakra type.';
    }
    }
}