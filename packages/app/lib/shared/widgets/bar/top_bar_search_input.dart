import 'dart:async';

import 'package:flutter/material.dart';

class TopBarSearchInput extends StatefulWidget {
  final String? defaultValue;
  final FocusNode? focusNode;
  final void Function(String) onSearchRequested;

  const TopBarSearchInput({
    super.key,
    required this.onSearchRequested,
    this.focusNode,
    this.defaultValue,
  });

  @override
  State<TopBarSearchInput> createState() => _TopBarSearchInputState();
}

class _TopBarSearchInputState extends State<TopBarSearchInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _changeDebounce;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.all(9),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(7),
        ),
        child: TextFormField(
          focusNode: _focusNode,
          style: Theme.of(context).textTheme.titleSmall,
          onEditingComplete: _handleEditingCompletion,
          onTapOutside: _handleOutsideTap,
          onChanged: _handleChange,
          decoration: InputDecoration(
            hintText: "Recherche",
            hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
            constraints: const BoxConstraints.expand(height: 32),
            contentPadding: EdgeInsets.zero,
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            border: InputBorder.none,
          ),
          controller: _controller,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _requestSearch() {
    final text = _controller.text;
    if (text.isNotEmpty) widget.onSearchRequested(text);
  }

  void _stopActiveDebounce() {
    if (_changeDebounce == null || !_changeDebounce!.isActive) return;
    _changeDebounce?.cancel();
  }

  void _handleEditingCompletion() {
    _stopActiveDebounce();
    _requestSearch();
    _focusNode.unfocus();
  }

  void _handleOutsideTap(PointerDownEvent _) {
    _stopActiveDebounce();
    _requestSearch();
    _focusNode.unfocus();
  }

  void _handleChange(String _) {
    _stopActiveDebounce();
    _changeDebounce = Timer(
      const Duration(milliseconds: 500),
      _requestSearch,
    );
  }
}
