import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int trimLines;
  final String? expandLabel;
  final String? collapseLabel;
  final TextAlign? textAlign;

  const ExpandableText({
    super.key,
    required this.text,
    this.style,
    this.trimLines = 4,
    this.expandLabel,
    this.collapseLabel,
    this.textAlign,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLong = widget.text.length > 200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: widget.trimLines,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
            textAlign: widget.textAlign,
          ),
          secondChild: Text(
            widget.text,
            style: widget.style,
            textAlign: widget.textAlign,
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (isLong)
          Semantics(
            button: true,
            label: _expanded ? 'Show less text' : 'Show more text',
            child: TextButton(
              onPressed: _toggle,
              child: Text(
                _expanded
                    ? (widget.collapseLabel ?? context.l10n.showLess)
                    : (widget.expandLabel ?? context.l10n.showMore),
              ),
            ),
          ),
      ],
    );
  }
}
