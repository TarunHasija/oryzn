import 'dart:async';

import 'package:flutter/material.dart';

class RotatingText extends StatefulWidget {
  const RotatingText({
    super.key,
    required this.texts,
    this.style,
    this.pauseDuration = const Duration(seconds: 4),
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final List<String> texts;
  final TextStyle? style;
  final Duration pauseDuration;
  final Duration transitionDuration;

  @override
  State<RotatingText> createState() => _RotatingTextState();
}

class _RotatingTextState extends State<RotatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _outSlide;
  late final Animation<Offset> _inSlide;
  late final Animation<double> _outOpacity;
  late final Animation<double> _inOpacity;

  int _currentIndex = 0;
  int _nextIndex = 1;
  Timer? _timer;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    );

    // Current text slides up and fades out
    _outSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _outOpacity = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Next text slides up from below
    _inSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _inOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex = _nextIndex;
          _nextIndex = (_nextIndex + 1) % widget.texts.length;
          _isTransitioning = false;
        });
        _controller.reset();
        _startTimer();
      }
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.pauseDuration, () {
      if (mounted) {
        setState(() => _isTransitioning = true);
        _controller.forward();
      }
    });
  }

  void _skipToNext() {
    if (_isTransitioning) return;
    _timer?.cancel();
    setState(() {
      _isTransitioning = true;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    if (!_isTransitioning) {
      return GestureDetector(
        onTap: _skipToNext,
        child: Text(widget.texts[_currentIndex], style: style),
      );
    }

    return ClipRect(
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          SlideTransition(
            position: _outSlide,
            child: FadeTransition(
              opacity: _outOpacity,
              child: Text(widget.texts[_currentIndex], style: style),
            ),
          ),
          SlideTransition(
            position: _inSlide,
            child: FadeTransition(
              opacity: _inOpacity,
              child: Text(widget.texts[_nextIndex], style: style),
            ),
          ),
        ],
      ),
    );
  }
}
