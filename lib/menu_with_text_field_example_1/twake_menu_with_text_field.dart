import 'package:flutter/material.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// A menu widget with an optional search text field header and a list of items.
/// Matches Figma spec: 200×296, vertical layout, light and dark variants.
class TwakeMenuWithTextField extends StatefulWidget {
  /// Optional label shown above the text field.
  final String? label;

  /// Whether to show the search text field at the top.
  final bool showTextField;

  /// Hint text inside the search field.
  final String textFieldHint;

  /// Current value of the search field.
  final String? textFieldValue;

  /// Called when the search field text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Called when the clear (×) button in the search field is tapped.
  final VoidCallback? onClearSearch;

  /// The list of menu item labels.
  final List<String> items;

  /// Called when a menu item is tapped, with its index.
  final ValueChanged<int>? onItemTap;

  /// Whether to render in dark mode.
  final bool isDark;

  const TwakeMenuWithTextField({
    Key? key,
    this.label,
    this.showTextField = true,
    this.textFieldHint = 'Input',
    this.textFieldValue,
    this.onSearchChanged,
    this.onClearSearch,
    this.items = const ['List item', 'List item', 'List item', 'List item'],
    this.onItemTap,
    this.isDark = false,
  }) : super(key: key);

  @override
  State<TwakeMenuWithTextField> createState() => _TwakeMenuWithTextFieldState();
}

class _TwakeMenuWithTextFieldState extends State<TwakeMenuWithTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.textFieldValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.isDark ? const Color(0xFF1C1B1F) : Colors.white;
    final surfaceColor =
        widget.isDark ? const Color(0xFF313033) : const Color(0xFFF4F4F4);
    final textColor =
        widget.isDark ? Colors.white : const Color(0xFF1C1B1F);
    final hintColor =
        widget.isDark ? const Color(0xFFCAC4D0) : const Color(0xFF49454F);
    final labelColor =
        widget.isDark ? const Color(0xFF938F99) : const Color(0xFF6750A4);
    final borderColor =
        widget.isDark ? const Color(0xFF938F99) : const Color(0xFF79747E);
    final iconColor =
        widget.isDark ? const Color(0xFFCAC4D0) : const Color(0xFF49454F);
    final dividerColor =
        widget.isDark ? const Color(0xFF49454F) : const Color(0xFFE7E0EC);

    return Material(
      color: backgroundColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showTextField)
              _SearchField(
                controller: _controller,
                label: widget.label,
                hint: widget.textFieldHint,
                textColor: textColor,
                hintColor: hintColor,
                labelColor: labelColor,
                borderColor: borderColor,
                iconColor: iconColor,
                backgroundColor: backgroundColor,
                onChanged: widget.onSearchChanged,
                onClear: () {
                  _controller.clear();
                  widget.onClearSearch?.call();
                },
              ),
            if (widget.showTextField)
              Divider(height: 1, thickness: 1, color: dividerColor),
            _MenuItemList(
              items: widget.items,
              textColor: textColor,
              onItemTap: widget.onItemTap,
              surfaceColor: surfaceColor,
              backgroundColor: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Private: search field with label and clear button.
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String hint;
  final Color textColor;
  final Color hintColor;
  final Color labelColor;
  final Color borderColor;
  final Color iconColor;
  final Color backgroundColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const _SearchField({
    required this.controller,
    this.label,
    required this.hint,
    required this.textColor,
    required this.hintColor,
    required this.labelColor,
    required this.borderColor,
    required this.iconColor,
    required this.backgroundColor,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(fontSize: 16, color: textColor),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: 12, color: labelColor),
              hintText: hint,
              hintStyle: TextStyle(fontSize: 16, color: hintColor),
              prefixIcon: Icon(Icons.search, size: 20, color: iconColor),
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel, size: 18, color: iconColor),
                padding: EdgeInsets.zero,
                onPressed: onClear,
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: labelColor, width: 2),
              ),
              filled: true,
              fillColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Private: scrollable list of menu items.
class _MenuItemList extends StatelessWidget {
  final List<String> items;
  final Color textColor;
  final Color surfaceColor;
  final Color backgroundColor;
  final ValueChanged<int>? onItemTap;

  const _MenuItemList({
    required this.items,
    required this.textColor,
    required this.surfaceColor,
    required this.backgroundColor,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _MenuItem(
          label: items[index],
          textColor: textColor,
          backgroundColor: backgroundColor,
          onTap: () => onItemTap?.call(index),
        );
      },
    );
  }
}

/// Private: single menu item row.
class _MenuItem extends StatefulWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: 48,
          color: _hovered
              ? widget.textColor.withOpacity(0.08)
              : widget.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
