part of alghwalbi_core;

class MultiSelectDialog extends StatefulWidget {
  List<dynamic> items;
  final List<dynamic> selectedItems;
  final void Function(List<dynamic>) onChange;
  final String? labelPropertyName;
  final bool Function(Map<String, dynamic>, String?)? seachFunction;
  MultiSelectDialog(this.items, this.selectedItems, this.onChange,
      {this.labelPropertyName, this.seachFunction});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<dynamic> notModifiedItems;
  final double _borderRadius = 16;
  final double _padding = 6;

  @override
  void initState() {
    notModifiedItems = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: Container()),
      Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          color: Colors.white,
          child: Container(
            height: 500.0,
            width: 300.0,
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_padding),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: ConfigService.isRTL ? 'بحث ...' : 'Search ...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_borderRadius))),
                  onChanged: (String? value) {
                    if (value == null || value == '') {
                      widget.items = notModifiedItems;
                    } else {
                      if (widget.seachFunction == null) {
                        widget.items = notModifiedItems
                            .where((element) =>
                                element['name']
                                        ?[ConfigService.isRTL ? 'ar' : 'en']
                                    .toString()
                                    .contains(value) ??
                                element['ar'].toString().contains(value))
                            .toList();
                      } else {
                        widget.items = notModifiedItems
                            .where((element) =>
                                widget.seachFunction!.call(element, value))
                            .toList();
                      }
                    }
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                  child: ListView(
                      padding: EdgeInsets.only(
                          left: _padding, right: _padding, top: _padding),
                      children: widget.items
                          .map((item) => MainCheckBox(
                                // item is Map<String,dynamic> ?
                                widget.selectedItems.any((e) =>
                                    (e['id'] != null &&
                                        e['id'] == item['id']) ||
                                    (e['_id'] != null &&
                                        e['_id'] == item['_id']) ||
                                    (e != null && e == item))
                                // :
                                , //widget.selectedItems.contains(item),
                                (item == null
                                        ? ''
                                        : (item is BaseModel)
                                            ? item.displayName
                                            : (item as dynamic)[
                                                    widget.labelPropertyName ??
                                                        'display'] is Map
                                                ? (item as dynamic)[widget
                                                        .labelPropertyName ??
                                                    'display'][ConfigService
                                                        .isRTL
                                                    ? 'ar'
                                                    : 'en']
                                                : (item as dynamic)[widget
                                                            .labelPropertyName ??
                                                        'display'] ??
                                                    (item as dynamic)['ar']) ??
                                    '',
                                (v) {
                                  if (v) {
                                    widget.selectedItems.add(item);
                                  } else {
                                    widget.selectedItems.removeWhere((e) =>
                                        (e['id'] != null &&
                                            e['id'] == item['id']) ||
                                        (e['_id'] != null &&
                                            e['_id'] == item['_id']) ||
                                        (e != null && e == item));
                                  }
                                  widget.onChange(widget.selectedItems);
                                  setState(() {
                                    print(widget.selectedItems.length);
                                  });
                                },
                                key: Key(item['_id'] ??
                                    item['id'] ??
                                    jsonEncode(item)),
                              ))
                          .toList()))
            ]),
          )),
      const SizedBox(height: 15.0),
      ButtonTheme(
          minWidth: 300.0,
          height: 60.0,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius)),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(widget.selectedItems),
            child: Text(ConfigService.isRTL ? 'تم' : 'Done',
                style: TextStyle(
                    color: ThemeService.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          )),
      Expanded(
        child: Container(),
      ),
    ]);
  }
}
