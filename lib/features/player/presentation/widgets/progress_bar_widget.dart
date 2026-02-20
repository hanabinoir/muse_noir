import 'package:flutter/material.dart';

/// Progress bar widget for audio playback
class ProgressBarWidget extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onSeek;
  final bool isEnabled;

  const ProgressBarWidget({
    super.key,
    required this.duration,
    required this.position,
    required this.onSeek,
    this.isEnabled = true,
  });

  @override
  State<ProgressBarWidget> createState() => _ProgressBarWidgetState();
}

class _ProgressBarWidgetState extends State<ProgressBarWidget> {
  late Duration _displayPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _displayPosition = widget.position;
  }

  @override
  void didUpdateWidget(ProgressBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging) {
      _displayPosition = widget.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: Colors.purple,
            inactiveTrackColor: Colors.grey[700],
            thumbColor: Colors.purple,
            overlayColor: Colors.purple.withOpacity(0.3),
          ),
          child: Slider(
            min: 0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: _displayPosition.inMilliseconds.toDouble(),
            onChanged: widget.isEnabled
                ? (value) {
                    setState(() {
                      _isDragging = true;
                      _displayPosition =
                          Duration(milliseconds: value.toInt());
                    });
                  }
                : null,
            onChangeEnd: (value) {
              setState(() => _isDragging = false);
              widget.onSeek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_displayPosition),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              Text(
                _formatDuration(widget.duration),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}

