part of alghwalbi_core;

class SelectDialog extends StatefulWidget {
  final List<dynamic> items;
  final dynamic selectedItem;
  final void Function(dynamic)? onSelectedChanged;
  const SelectDialog(
      {Key? key,
      required this.items,
      this.selectedItem,
      this.onSelectedChanged})
      : super(key: key);

  @override
  _SelectDialogState createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  String? groupId;
  String? selectedItem;
  @override
  void initState() {
    selectedItem = widget.selectedItem.toString();
    groupId = 'groupId';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((e) => _getRow(e)).toList(),
    );
  }

  Widget _getRow(row) {
    return MaterialButton(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 12,
        ),
        onPressed: () {
          setState(() {
            selectedItem = row.toString();
            if (widget.onSelectedChanged != null)
              widget.onSelectedChanged?.call(selectedItem);
          });
        },
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 4, right: 5),
                child: Radio(
                    value: row.toString(),
                    groupValue: selectedItem,
                    onChanged: (v) {})),
            Text(
              row.toString(),
              style: TextStyle(
                color: CoreApp.themeConfig.textMainColor,
                fontSize: 18,
              ),
            )
          ],
        ));
  }
}
