import 'package:flutter/material.dart';
import 'search_dialog.dart';

class DropdownWithSearch<T> extends StatelessWidget {
  final String title;
  final String placeHolder;
  final T selected;
  final List items;
  final EdgeInsets? selectedItemPadding;
  final TextStyle? selectedItemStyle;
  final TextStyle? dropdownHeadingStyle;
  final TextStyle? itemStyle;
  final BoxDecoration? decoration, disabledDecoration;
  final double? searchBarRadius;
  final double? dialogRadius;
  final bool disabled;
  final String label;

  final Function onChanged;

  const DropdownWithSearch({
    Key? key,
    required this.title,
    required this.placeHolder,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.selectedItemPadding,
    this.selectedItemStyle,
    this.dropdownHeadingStyle,
    this.itemStyle,
    this.decoration,
    this.disabledDecoration,
    this.searchBarRadius,
    this.dialogRadius,
    required this.label,
    this.disabled = false,
  }) : super(key: key);

  void _onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SearchDialog(
        placeHolder: placeHolder,
        title: title,
        searchInputRadius: searchBarRadius,
        dialogRadius: dialogRadius,
        titleStyle: dropdownHeadingStyle,
        itemStyle: itemStyle,
        items: items,
      ),
    ).then((value) {
      onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: disabled,
      child: GestureDetector(
        onTap: () => _onTap(context),
        child: Container(
          padding: selectedItemPadding ??
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: !disabled
              ? decoration ??
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  )
              : disabledDecoration ??
                  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selected.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: selectedItemStyle ?? const TextStyle(fontSize: 14),
                ),
              ),
              if (!disabled) const Icon(Icons.keyboard_arrow_down_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
