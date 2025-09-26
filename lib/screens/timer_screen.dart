import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/timer_settings.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  TimerSettings _settings = TimerSettings();
  final SettingsService _settingsService = SettingsService();
  int _elapsedMilliseconds = 0;
  bool _isRunning = false;
  int _pausedMilliseconds = 0;  // Store time when paused
  bool _hasStartedOnce = false;  // Track if timer has been started at least once

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final loadedSettings = await _settingsService.loadSettings();
    setState(() {
      _settings = loadedSettings;
    });
  }

  Future<void> _saveSettings() async {
    await _settingsService.saveSettings(_settings);
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;

        // First time starting with delay
        if (!_hasStartedOnce && _settings.startDelaySeconds > 0) {
          _pausedMilliseconds = -(_settings.startDelaySeconds * 1000);
          _hasStartedOnce = true;
        }

        // If we haven't started once yet (fresh start)
        if (!_hasStartedOnce) {
          _hasStartedOnce = true;
        }
      });

      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 1), (_) {
        setState(() {
          _elapsedMilliseconds = _pausedMilliseconds + _stopwatch.elapsedMilliseconds;
        });
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
        // Store the current elapsed time for resuming
        _pausedMilliseconds = _elapsedMilliseconds;
      });
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _elapsedMilliseconds = 0;
      _pausedMilliseconds = 0;
      _hasStartedOnce = false;
    });
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
  }

  void _recordLap() {
    if (_isRunning) {
      final lapTime = _formatTime(_elapsedMilliseconds);
      setState(() {
        _settings.laps.add(lapTime);
      });
      _saveSettings();
    }
  }

  void _clearLaps() {
    setState(() {
      _settings.laps.clear();
    });
    _saveSettings();
  }

  String _formatTime(int milliseconds) {
    final isNegative = milliseconds < 0;
    final absMilliseconds = milliseconds.abs();
    final minutes = (absMilliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((absMilliseconds % 60000) ~/ 1000).toString().padLeft(2, '0');
    final ms = (absMilliseconds % 1000).toString().padLeft(3, '0');
    return '${isNegative ? '-' : ''}$minutes:$seconds:$ms';
  }

  Widget _buildTimer() {
    // Determine what time to display
    String timeString;
    if (_elapsedMilliseconds < 0 && _isRunning) {
      // During countdown, show 00:00:000
      timeString = '00:00:000';
    } else if (!_hasStartedOnce) {
      // Never started, show 00:00:000
      timeString = '00:00:000';
    } else {
      // Show actual time (running or paused)
      timeString = _formatTime(_elapsedMilliseconds);
    }

    // Invert colors when timer is not running or during delay countdown
    final bool isInactive = !_isRunning || _elapsedMilliseconds < 0;
    final backgroundColor = isInactive
        ? _settings.digitColor
        : _settings.digitBackgroundColor;
    final textColor = isInactive
        ? _settings.digitBackgroundColor
        : _settings.digitColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        timeString,
        style: TextStyle(
          fontSize: _settings.digitFontSize,
          color: textColor,
          fontFamily: 'Courier New',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progressMillis = _elapsedMilliseconds >= 0
        ? _elapsedMilliseconds % 1000
        : 0;

    return Container(
      width: 1000,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1),
            width: progressMillis.toDouble(),
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    if (_settings.labelText.isEmpty) {
      return const SizedBox.shrink();
    }

    final label = Text(
      _settings.labelText,
      style: TextStyle(
        fontSize: _settings.labelFontSize,
        color: _settings.labelFontColor,
        fontWeight: FontWeight.bold,
      ),
    );

    switch (_settings.labelPosition) {
      case LabelPosition.top:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: label,
        );
      case LabelPosition.bottom:
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: label,
        );
      case LabelPosition.left:
      case LabelPosition.right:
        return label;
    }
  }

  Widget _buildDelayIndicator() {
    if (_elapsedMilliseconds >= 0 || !_isRunning) {
      return const SizedBox.shrink();
    }

    final delaySeconds = (-_elapsedMilliseconds / 1000).ceil();
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(204),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Starting in: $delaySeconds',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTimerWithLabel() {
    final timer = _buildTimer();
    final label = _buildLabel();

    if (_settings.labelText.isEmpty) {
      return timer;
    }

    switch (_settings.labelPosition) {
      case LabelPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [label, timer],
        );
      case LabelPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [timer, label],
        );
      case LabelPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [label, const SizedBox(width: 20), timer],
        );
      case LabelPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [timer, const SizedBox(width: 20), label],
        );
    }
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          message: 'Press Space',
          child: ElevatedButton.icon(
            onPressed: _isRunning ? _stopTimer : _startTimer,
            icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
            label: Text(_isRunning ? 'Stop' : 'Start'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Tooltip(
          message: 'Press R',
          child: ElevatedButton.icon(
            onPressed: _resetTimer,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Tooltip(
          message: 'Press L',
          child: ElevatedButton.icon(
            onPressed: _isRunning ? _recordLap : null,
            icon: const Icon(Icons.flag),
            label: const Text('Lap'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLapsList() {
    if (_settings.laps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lap Times',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _clearLaps,
                child: const Text('Clear All'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _settings.laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    _settings.laps[index],
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            // Toggle timer with spacebar
            if (_isRunning) {
              _stopTimer();
            } else {
              _startTimer();
            }
          } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
            // Reset with 'R' key
            _resetTimer();
          } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
            // Record lap with 'L' key
            _recordLap();
          }
        }
      },
      child: Scaffold(
        backgroundColor: _settings.globalBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimerWithLabel(),
                        const SizedBox(height: 40),
                        _buildProgressBar(),
                        const SizedBox(height: 40),
                        _buildControls(),
                        const SizedBox(height: 30),
                        _buildLapsList(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildDelayIndicator(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final updatedSettings = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(settings: _settings),
              ),
            );
            if (updatedSettings != null) {
              setState(() {
                _settings = updatedSettings;
              });
              _saveSettings();
            }
          },
          child: const Icon(Icons.settings),
        ),
      ),
    );
  }
}