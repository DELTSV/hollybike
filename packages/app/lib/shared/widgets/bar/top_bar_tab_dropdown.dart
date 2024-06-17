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
        initialSelection: 0,
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
    widget.controller.addListener(() {
      controller.value = TextEditingValue(
        text: widget.entries[widget.controller.index].title,
      );
    });

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<DropdownMenuEntry<int>> _renderMenuEntries() {
    final entries = <DropdownMenuEntry<int>>[];
    for (int i = 0; i < widget.entries.length; i++) {
      entries.add(
        DropdownMenuEntry(
          value: i,
          label: widget.entries[i].title,
          trailingIcon: Icon(widget.entries[i].icon),
        ),
      );
    }
    return entries;
  }

  void _handleSelectedValueChange(int? value) {
    widget.controller.animateTo(value as int);
  }
}
