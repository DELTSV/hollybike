import 'package:flutter/material.dart';

class TabDropdownEntry {
  final String title;
  final IconData icon;

  const TabDropdownEntry({
    required this.title,
    required this.icon,
  });
}

class TopBarTabDropdown extends StatefulWidget {
  final List<TabDropdownEntry> entries;
  final TabController controller;

  const TopBarTabDropdown({
    super.key,
    required this.entries,
    required this.controller,
  });

  @override
  State<TopBarTabDropdown> createState() => _TopBarTabDropdownState();
}

class _TopBarTabDropdownState extends State<TopBarTabDropdown> {
  late final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: DropdownMenu(
        initialSelection: widget.controller.index,
        controller: controller,
        textStyle: Theme.of(context).textTheme.titleMedium,
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.only(left: 16),
          border: InputBorder.none,
        ),
        menuStyle: MenuStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor:
              WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
        ),
        onSelected: _handleSelectedValueChange,
        dropdownMenuEntries: _renderMenuEntries(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    widget.controller.animation?.addListener(_updateTitle);
  }

  @override
  void dispose() {
    controller.dispose();
    widget.controller.removeListener(_updateTitle);
    super.dispose();
  }

  void _updateTitle() {
    final newTab = widget.controller.animation!.value.round();

    if (widget.controller.index != newTab) {
      controller.value = TextEditingValue(
        text: widget.entries[newTab].title,
      );
    }
  }

  List<DropdownMenuEntry<int>> _renderMenuEntries() {
    final entries = <DropdownMenuEntry<int>>[];
    for (int i = 0; i < widget.entries.length; i++) {
      entries.add(
        DropdownMenuEntry(
          value: i,
          labelWidget: _animate(Text(widget.entries[i].title), i),
          trailingIcon: _animate(Icon(widget.entries[i].icon), i),
          label: widget.entries[i].title,
        ),
      );
    }
    return entries;
  }

  Widget _animate(Widget child, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 120 * index),
      curve: Curves.ease,
      builder: (context, double value, _) {
        if (value != 1) {
          return const SizedBox();
        }

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 350),
          curve: Curves.ease,
          builder: (context, double value, _) {
            return Transform.translate(
              offset: Offset(30 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: Expanded(child: child),
              ),
            );
          },
        );
      },
    );
  }

  void _handleSelectedValueChange(int? value) {
    widget.controller.animateTo(value as int);
  }
}
