import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import 'vedic_components.dart';

class YogaSessionPlayer extends StatefulWidget {
  final String title;
  final String duration;
  final String description;
  final String imageAsset;
  final List<String> instructions;
  final VoidCallback? onComplete;

  const YogaSessionPlayer({
    super.key,
    required this.title,
    required this.duration,
    required this.description,
    required this.imageAsset,
    required this.instructions,
    this.onComplete,
  });

  @override
  State<YogaSessionPlayer> createState() => _YogaSessionPlayerState();
}

class _YogaSessionPlayerState extends State<YogaSessionPlayer> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
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
          _isPlaying = false;
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _currentSeconds = 0;
      _isPlaying = false;
      _timer?.cancel();
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
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              widget.imageAsset,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
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
                
                // Instructions
                if (widget.instructions.isNotEmpty) ...[  
                  Text(
                    'Instructions:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.instructions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final instruction = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. ', style: Theme.of(context).textTheme.bodyMedium),
                          Expanded(child: Text(instruction, style: Theme.of(context).textTheme.bodyMedium)),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MeditationMusicPlayer extends StatefulWidget {
  final String title;
  final String duration;
  final String imageAsset;
  final String audioAsset;
  final String? chakraType;

  const MeditationMusicPlayer({
    super.key,
    required this.title,
    required this.duration,
    required this.imageAsset,
    required this.audioAsset,
    this.chakraType,
  });

  @override
  State<MeditationMusicPlayer> createState() => _MeditationMusicPlayerState();
}

class _MeditationMusicPlayerState extends State<MeditationMusicPlayer> {
  bool _isPlaying = false;
  int _currentSeconds = 0;
  int _totalSeconds = 300; // Default 5 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Parse duration string (e.g., "5:00")
    final durationParts = widget.duration.split(':');
    if (durationParts.length == 2) {
      final minutes = int.tryParse(durationParts[0]) ?? 0;
      final seconds = int.tryParse(durationParts[1]) ?? 0;
      _totalSeconds = (minutes * 60) + seconds;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _startTimer();
      } else {
        _timer?.cancel();
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
          _isPlaying = false;
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
            ],
          ),
          
          // Player controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
                              ? AppTheme.primaryColor.withOpacity(0.5 + (index % 3) * 0.2)
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
                  color: widget.chakraType != null
                      ? _getChakraColor(widget.chakraType!)
                      : AppTheme.primaryColor,
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
              ],
            ),
          ),
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
}