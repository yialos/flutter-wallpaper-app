import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A grid widget that supports keyboard navigation for Desktop/Web
/// Requirements: 10.5, Task 28.1
class KeyboardNavigableGrid extends StatefulWidget {
  final int itemCount;
  final int crossAxisCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final void Function(int)? onItemSelected;

  const KeyboardNavigableGrid({
    super.key,
    required this.itemCount,
    required this.crossAxisCount,
    required this.itemBuilder,
    this.scrollController,
    this.padding,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.onItemSelected,
  });

  @override
  State<KeyboardNavigableGrid> createState() => _KeyboardNavigableGridState();
}

class _KeyboardNavigableGridState extends State<KeyboardNavigableGrid> {
  int _focusedIndex = 0;
  final FocusNode _gridFocusNode = FocusNode();

  @override
  void dispose() {
    _gridFocusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final oldIndex = _focusedIndex;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        if (_focusedIndex % widget.crossAxisCount > 0) {
          _focusedIndex--;
        }
        break;
      case LogicalKeyboardKey.arrowRight:
        if (_focusedIndex % widget.crossAxisCount < widget.crossAxisCount - 1 &&
            _focusedIndex < widget.itemCount - 1) {
          _focusedIndex++;
        }
        break;
      case LogicalKeyboardKey.arrowUp:
        if (_focusedIndex >= widget.crossAxisCount) {
          _focusedIndex -= widget.crossAxisCount;
        }
        break;
      case LogicalKeyboardKey.arrowDown:
        if (_focusedIndex + widget.crossAxisCount < widget.itemCount) {
          _focusedIndex += widget.crossAxisCount;
        }
        break;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        widget.onItemSelected?.call(_focusedIndex);
        break;
      case LogicalKeyboardKey.home:
        _focusedIndex = 0;
        break;
      case LogicalKeyboardKey.end:
        _focusedIndex = widget.itemCount - 1;
        break;
    }

    if (oldIndex != _focusedIndex) {
      setState(() {});
      _scrollToFocusedItem();
    }
  }

  void _scrollToFocusedItem() {
    if (widget.scrollController == null) return;

    // Calculate approximate position of focused item
    final row = _focusedIndex ~/ widget.crossAxisCount;
    final itemHeight =
        MediaQuery.of(context).size.width /
        widget.crossAxisCount *
        (1 / widget.childAspectRatio);
    final targetOffset = row * (itemHeight + widget.mainAxisSpacing);

    widget.scrollController!.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _gridFocusNode,
      onKeyEvent: (node, event) {
        _handleKeyEvent(event);
        return KeyEventResult.handled;
      },
      child: GridView.builder(
        controller: widget.scrollController,
        padding: widget.padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
          childAspectRatio: widget.childAspectRatio,
        ),
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          final isFocused = index == _focusedIndex;

          return Focus(
            onFocusChange: (hasFocus) {
              if (hasFocus) {
                setState(() {
                  _focusedIndex = index;
                });
              }
            },
            child: Container(
              decoration: isFocused
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: widget.itemBuilder(context, index),
            ),
          );
        },
      ),
    );
  }
}
