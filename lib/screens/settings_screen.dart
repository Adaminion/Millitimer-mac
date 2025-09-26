import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/timer_settings.dart';

class SettingsScreen extends StatefulWidget {
  final TimerSettings settings;

  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TimerSettings _settings;
  late TextEditingController _labelTextController;
  late TextEditingController _startDelayController;
  final FocusNode _labelTextFocusNode = FocusNode();
  final FocusNode _startDelayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _settings = widget.settings.copyWith();
    _labelTextController = TextEditingController(text: _settings.labelText);
    _startDelayController = TextEditingController(text: _settings.startDelaySeconds.toString());
  }

  @override
  void dispose() {
    _labelTextController.dispose();
    _startDelayController.dispose();
    _labelTextFocusNode.dispose();
    _startDelayFocusNode.dispose();
    super.dispose();
  }

  void _saveAndExit() {
    // Add current text to recent list if not empty
    if (_settings.labelText.isNotEmpty) {
      _settings.addRecentCustomText(_settings.labelText);
    }
    Navigator.pop(context, _settings);
  }

  String _getColorName(Color color) {
    if (color == Colors.white) return 'White';
    if (color == Colors.black) return 'Black';
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.cyan) return 'Cyan';
    if (color == Colors.grey) return 'Grey';
    if ((((color.a * 255.0).round() & 0xff) << 24 |
         ((color.r * 255.0).round() & 0xff) << 16 |
         ((color.g * 255.0).round() & 0xff) << 8 |
         ((color.b * 255.0).round() & 0xff)) == 0xFF202020) {
      return 'Dark Grey';
    }
    return 'Custom Color';
  }

  void _selectColor(String title, Color currentColor, Function(Color) onColorSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final color in [
                  Colors.white,
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.orange,
                  Colors.purple,
                  Colors.pink,
                  Colors.cyan,
                  Colors.grey,
                  const Color(0xFF202020),
                ])
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    title: Text(_getColorName(color)),
                    onTap: () {
                      onColorSelected(color);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: _saveAndExit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
              'Timer Display',
              [
                ListTile(
                  title: const Text('Font Size'),
                  subtitle: Slider(
                    value: _settings.digitFontSize,
                    min: 30,
                    max: 150,
                    divisions: 24,
                    label: _settings.digitFontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _settings.digitFontSize = value;
                      });
                    },
                  ),
                  trailing: Text('${_settings.digitFontSize.round()}px'),
                ),
                ListTile(
                  title: const Text('Text Color'),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _settings.digitColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onTap: () {
                    _selectColor('Select Timer Color', _settings.digitColor, (color) {
                      setState(() {
                        _settings.digitColor = color;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('Background Color'),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _settings.digitBackgroundColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onTap: () {
                    _selectColor('Select Timer Background', _settings.digitBackgroundColor, (color) {
                      setState(() {
                        _settings.digitBackgroundColor = color;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('Start Delay (seconds)'),
                  subtitle: TextField(
                    controller: _startDelayController,
                    focusNode: _startDelayFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: 'Enter delay in seconds (0 for no delay)',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _settings.startDelaySeconds = int.tryParse(value) ?? 0;
                      });
                    },
                    onSubmitted: (_) {
                      _saveAndExit();
                    },
                  ),
                ),
              ],
            ),
            _buildSection(
              'Custom Label',
              [
                if (_settings.recentCustomTexts.isNotEmpty) ...[
                  ListTile(
                    title: const Text('Recent Labels'),
                    subtitle: DropdownButton<String>(
                      hint: const Text('Select from recent'),
                      isExpanded: true,
                      value: null,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            _settings.labelText = value;
                            _labelTextController.text = value;
                          });
                        }
                      },
                      items: _settings.recentCustomTexts.map((text) {
                        return DropdownMenuItem<String>(
                          value: text,
                          child: Text(
                            text,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                ListTile(
                  title: const Text('Label Text'),
                  subtitle: TextField(
                    controller: _labelTextController,
                    focusNode: _labelTextFocusNode,
                    decoration: const InputDecoration(
                      hintText: 'Enter custom label (e.g., Camera #2)',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _settings.labelText = value;
                      });
                    },
                    onSubmitted: (_) {
                      _saveAndExit();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Label Font Size'),
                  subtitle: Slider(
                    value: _settings.labelFontSize,
                    min: 12,
                    max: 60,
                    divisions: 16,
                    label: _settings.labelFontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _settings.labelFontSize = value;
                      });
                    },
                  ),
                  trailing: Text('${_settings.labelFontSize.round()}px'),
                ),
                ListTile(
                  title: const Text('Label Color'),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _settings.labelFontColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onTap: () {
                    _selectColor('Select Label Color', _settings.labelFontColor, (color) {
                      setState(() {
                        _settings.labelFontColor = color;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('Label Position'),
                  subtitle: DropdownButton<LabelPosition>(
                    value: _settings.labelPosition,
                    isExpanded: true,
                    onChanged: (LabelPosition? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _settings.labelPosition = newValue;
                        });
                      }
                    },
                    items: LabelPosition.values.map((position) {
                      return DropdownMenuItem<LabelPosition>(
                        value: position,
                        child: Text(position.toString().split('.').last.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            _buildSection(
              'Global Settings',
              [
                ListTile(
                  title: const Text('Background Color'),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _settings.globalBackgroundColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onTap: () {
                    _selectColor('Select Background Color', _settings.globalBackgroundColor, (color) {
                      setState(() {
                        _settings.globalBackgroundColor = color;
                      });
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}