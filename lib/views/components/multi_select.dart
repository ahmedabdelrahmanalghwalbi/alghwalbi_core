part of alghwalbi_core;

class MultiSelectComponent<T> extends StatefulWidget {
  final List<T> items;
  final String title;
  final List<T>? initalSelect;
  final void Function(List<dynamic>?) onChange;
  final String? labelPropertyName;

  MultiSelectComponent(
      {required this.title,
      required this.items,
      required this.onChange,
      this.initalSelect,
      this.labelPropertyName});

  @override
  _MultiSelectComponentState<T> createState() =>
      _MultiSelectComponentState<T>();
}

class _MultiSelectComponentState<T> extends State<MultiSelectComponent> {
  List<T> selectedItems = [];
  List<T> items = [];

  @override
  void initState() {
    items = widget.items.cast<T>();
    selectedItems = widget.initalSelect?.cast<T>() ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      //padding: EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: selectedItems.length == 0 ? 15.0 : 5.0),
          if (selectedItems.length > 0)
            Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(widget.title,
                    style: TextStyle(
                        color: Colors.black45,
                        // fontWeight: FontWeight.normal,
                        fontSize: 13))),
          selectedItems.length == 0
              ? Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(widget.title,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal)))
              : Wrap(
                  spacing: 3.0,
                  children: selectedItems.map((d) {
                    return Chip(
                        label: Text(
                      d is BaseModel
                          ? d.displayName
                          : (d as dynamic)[
                                  widget.labelPropertyName ?? 'display'] is Map
                              ? (d as dynamic)[widget.labelPropertyName ??
                                  'display'][ConfigService.isRTL ? 'ar' : 'en']
                              : (d as dynamic)[
                                      widget.labelPropertyName ?? 'display'] ??
                                  d['ar'],
                    ));
                  }).toList()),
          //style:TextStyle(fontSize: 18.0, color: Colors.black)),
          SizedBox(height: 5.0),
          Container(
            // margin: EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
            height: 1.0,
            color: Colors.black,
          ),
          SizedBox(height: 20.0),
        ],
      ),
      onPressed: () {
        openMultiSelectDialog();
      },
    );
  }

  openMultiSelectDialog() {
    AppNavigator.showAppDialog(
        context,
        (_) => MultiSelectDialog(items, selectedItems, (List<dynamic> data) {
              widget.onChange(data.map<dynamic>((e) => e as dynamic).toList());
              setState(() {});
            }, labelPropertyName: widget.labelPropertyName),
        animationType: DialogAnimationTypes.feedIn);
  }
}

class MainCheckBox extends StatefulWidget {
  final bool initValue;
  final String title;
  final dynamic onChange;
  MainCheckBox(this.initValue, this.title, this.onChange, {Key? key})
      : super(key: key);
  @override
  _MainCheckBoxState createState() => _MainCheckBoxState();
}

class _MainCheckBoxState extends State<MainCheckBox> {
  bool value = false;
  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  onChange() {
    AppNavigator.hapticFeedback(heavy: false);
    value = !value;
    setState(() {});
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 8.0),
        TextButton(
            onPressed: onChange,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Text(widget.title,
                          textAlign: TextAlign.left,
                          style: value
                              ? Theme.of(context).textTheme.headline1?.copyWith(
                                  color: ThemeService.mainColor, fontSize: 16)
                              : Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(fontSize: 16),
                          softWrap: true,
                          maxLines: 1)),
                  const SizedBox(width: 4),
                  value
                      ? CircleAvatar(
                          backgroundColor: ThemeService.backgroundSecondColor,
                          foregroundColor: ThemeService.mainColor,
                          child: Icon(
                            Icons.done,
                            size: 25.0,
                          ),
                          maxRadius: 15.0)
                      : CircleAvatar(
                          maxRadius: 15.0,
                          backgroundColor: ThemeService.backgroundSecondColor)
                ])),
        SizedBox(height: 8.0),
        Divider(
          color: ThemeService.secondryColor,
        )
      ],
    );
  }
}
