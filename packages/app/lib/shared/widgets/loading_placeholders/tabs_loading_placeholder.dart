import 'package:flutter/material.dart';

import '../profile_pictures/loading_profile_picture.dart';
import 'gradient_loading_placeholder.dart';

class TabsLoadingPlaceholder extends StatefulWidget {
  final int length;

  const TabsLoadingPlaceholder({super.key, required this.length});

  @override
  State<TabsLoadingPlaceholder> createState() => _TabsLoadingPlaceholderState();
}

class _TabsLoadingPlaceholderState extends State<TabsLoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  Widget build(BuildContext context) {
    const loadingTabIcon = Tab(
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: LoadingProfilePicture(size: 32),
      ),
    );

    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _controller,
            labelColor: Theme.of(context).colorScheme.secondary,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: Iterable.generate(
              widget.length,
              (_) => loadingTabIcon,
            ).toList(),
          ),
          const Expanded(
            child: SizedBox.expand(
              child: GradientLoadingPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
