import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HorizontalCarousel extends StatefulWidget {
  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? itemExtent;
  final double? separatorWidth;
  final EdgeInsetsGeometry? padding;

  const HorizontalCarousel({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    this.itemExtent,
    this.separatorWidth,
    this.padding,
  });

  @override
  State<HorizontalCarousel> createState() => _HorizontalCarouselState();
}

class _HorizontalCarouselState extends State<HorizontalCarousel> {
  final _scrollController = ScrollController();
  bool _isDragging = false;
  double _dragStartScrollOffset = 0;
  double _dragStartGlobalX = 0;

  bool get _useGrabToScroll {
    if (kIsWeb) return true;
    if (!Platform.isAndroid && !Platform.isIOS) return true;
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartScrollOffset = _scrollController.offset;
    _dragStartGlobalX = details.globalPosition.dx;
    _isDragging = false;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = _dragStartGlobalX - details.globalPosition.dx;
    if (!_isDragging && delta.abs() > 6) {
      setState(() => _isDragging = true);
    }
    if (!_isDragging) return;
    _scrollController.jumpTo(
      (_dragStartScrollOffset + delta).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
    );
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 50) {
      final target = (_scrollController.offset - velocity * 0.15).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        target,
        duration: Duration(
          milliseconds: (velocity.abs() * 0.5).toInt().clamp(100, 400),
        ),
        curve: Curves.easeOut,
      );
    }
    setState(() => _isDragging = false);
  }

  Widget _buildListView() {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        itemCount: widget.itemCount,
        itemExtent: widget.itemExtent,
        physics: _isDragging
            ? const NeverScrollableScrollPhysics()
            : null,
        itemBuilder: (context, index) {
          final child = widget.itemBuilder(context, index);
          if (widget.separatorWidth != null && index < widget.itemCount - 1) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                SizedBox(width: widget.separatorWidth),
              ],
            );
          }
          return child;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_useGrabToScroll) {
      return _buildListView();
    }

    return MouseRegion(
      cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.opaque,
        child: _buildListView(),
      ),
    );
  }
}
