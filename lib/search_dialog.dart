import 'package:flutter/material.dart';
import 'custom_dialog.dart';

class SearchDialog extends StatefulWidget {
  final String title;
  final String placeHolder;
  final List items;
  final TextStyle? titleStyle;
  final TextStyle? itemStyle;
  final double? searchInputRadius;
  final double? dialogRadius;

  const SearchDialog({
    Key? key,
    required this.title,
    required this.placeHolder,
    required this.items,
    this.titleStyle,
    this.searchInputRadius,
    this.dialogRadius,
    this.itemStyle,
  }) : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _textController = TextEditingController();
  late List filteredList;

  @override
  void initState() {
    super.initState();
    filteredList = widget.items;
    _textController.addListener(_filterList);
  }

  @override
  void dispose() {
    _textController.removeListener(_filterList);
    _textController.dispose();
    super.dispose();
  }

  void _filterList() {
    if (!mounted) return;
    setState(() {
      if (_textController.text.isEmpty) {
        filteredList = widget.items;
      } else {
        filteredList = widget.items
            .where((element) => element
                .toString()
                .toLowerCase()
                .contains(_textController.text.toLowerCase()))
            .toList();
      }
    });
  }

  void _onClose() {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _onSelectItem(dynamic item) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      shape: RoundedRectangleBorder(
        borderRadius: widget.dialogRadius != null
            ? BorderRadius.circular(widget.dialogRadius!)
            : BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title,
                    style: widget.titleStyle ??
                        const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _onClose,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search),
                  hintText: widget.placeHolder,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      widget.searchInputRadius != null
                          ? Radius.circular(widget.searchInputRadius!)
                          : const Radius.circular(5),
                    ),
                    borderSide: const BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      widget.searchInputRadius != null
                          ? Radius.circular(widget.searchInputRadius!)
                          : const Radius.circular(5),
                    ),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
                style: widget.itemStyle ?? const TextStyle(fontSize: 14),
                controller: _textController,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  widget.dialogRadius != null
                      ? Radius.circular(widget.dialogRadius!)
                      : const Radius.circular(5),
                ),
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return InkWell(
                      onTap: () => _onSelectItem(item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        child: Text(
                          item.toString(),
                          style: widget.itemStyle ??
                              const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
