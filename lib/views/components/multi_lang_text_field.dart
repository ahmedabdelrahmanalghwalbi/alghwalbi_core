part of alghwalbi_core;

class MultiLangTextField extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(Map<String, dynamic>) onChangedEx;
  final void Function()? onEditingComplete;
  final void Function(String value)? onFieldSubmitted;
  final List<TextInputFormatter>? formatters;
  final AutovalidateMode? autovalidateMode;
  final Axis? toggleBtnsDirection;

  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? regExp;
  final String? validateMessage;
  final double? labelSize;
  final Color? labelColor;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? description;
  final bool isRequired;
  final bool labelInHeader;
  final bool obscureText;
  final bool autoFocus;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final TextDirection? textDirection;
  final TextStyle? textStyle;
  final bool? enabled;
  final InputDecoration? decoration;
  final bool isMarkdown;

  const MultiLangTextField(
      {required this.data,
      required this.onChangedEx,
      this.toggleBtnsDirection,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.formatters,
      this.autovalidateMode,
      this.textDirection,
      this.obscureText = false,
      this.textInputAction,
      this.keyboardType,
      this.focusNode,
      this.validator,
      this.isRequired = false,
      this.validateMessage,
      this.regExp,
      this.maxLines,
      this.minLines,
      this.autoFocus = false,
      this.labelInHeader = false,
      this.enabled,
      this.textStyle,
      this.labelSize,
      this.labelColor = Colors.grey,
      this.decoration,
      this.description,
      this.labelText,
      this.isMarkdown = false,
      Key? key})
      : super(key: key);

  @override
  State<MultiLangTextField> createState() => _AppTextTransState();
}

class _AppTextTransState extends State<MultiLangTextField> {
  List<Map<String, dynamic>> myOptions = [
    {"label": 'en', 'isSelected': !ConfigService.isRTL},
    {"label": 'ar', 'isSelected': ConfigService.isRTL},
  ];

  String? _selectedLang;

  Map<String, dynamic>? _controllerData;

  var textEdittingController = TextEditingController();
  bool isShown = false;

  @override
  void initState() {
    for (var option in myOptions) {
      _controllerData ??= {};
      _controllerData?[option['label'] ?? ''] = '';
    }
    _selectedLang = myOptions
        .where((element) => element['isSelected'] == true)
        .first['label'];
    if (widget.data.isNotEmpty) {
      _controllerData = widget.data;
      textEdittingController.text = _controllerData?[_selectedLang] ?? '';
      if (textEdittingController.text == '' &&
          (_controllerData?[myOptions
                  .where((element) => element['isSelected'] != true)
                  .first['label']]) !=
              '') {
        textEdittingController.text = _controllerData?[myOptions
                .where((element) => element['isSelected'] != true)
                .first['label']] ??
            '';

        for (var option in myOptions) {
          option['isSelected'] = !option['isSelected'];
        }
      }
      textEdittingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEdittingController.text.length));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: widget.description ?? '',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !widget.labelInHeader
                ? const SizedBox()
                : Row(
                    children: [
                      Text(
                          '${widget.labelText} ${widget.isRequired ? '*' : ''}',
                          style: TextStyle(fontSize: widget.labelSize)),
                      const SizedBox(
                        width: 10,
                      ),
                      toggleBtnsWidget(),
                    ],
                  ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: widget.isMarkdown
                      ? SizedBox(
                          height: 250,
                          width: 500,
                          child: isShown
                              ? Markdown(
                                  data: _controllerData?[_selectedLang ?? ''],
                                  selectable: true,
                                  onTapText: () {
                                    isShown = !isShown;
                                    setState(() {});
                                  },
                                )
                              : MarkdownTextInput(
                                  (String v) {
                                    _controllerData?[_selectedLang ?? ''] =
                                        textEdittingController.text;
                                    widget.onChangedEx(_controllerData ?? {});
                                  },
                                  _controllerData?[_selectedLang ?? ''],
                                  controller: textEdittingController,
                                  actions: MarkdownType.values,
                                ),
                        )
                      : TextFormField(
                          inputFormatters: widget.formatters,
                          autovalidateMode: widget.autovalidateMode,
                          textAlign: _selectedLang == 'en'
                              ? TextAlign.left
                              : TextAlign.right,
                          textDirection: TextDirection.ltr,
                          enableInteractiveSelection: !widget.obscureText,
                          textInputAction: widget.textInputAction,
                          keyboardType: widget.keyboardType,
                          controller: textEdittingController,
                          onChanged: (v) {
                            _controllerData?[_selectedLang ?? ''] =
                                textEdittingController.text;
                            widget.onChangedEx(_controllerData ?? {});
                          },
                          onEditingComplete: widget.onEditingComplete,
                          onFieldSubmitted: widget.onFieldSubmitted,
                          focusNode: widget.focusNode,
                          validator: widget.validator ??
                              (val) {
                                if (val == null || val.isEmpty)
                                  return widget.isRequired
                                      ? widget.validateMessage ?? 'Required'
                                      : null;
                                if (widget.regExp == null) return null;
                                if (!RegExp(widget.regExp!).hasMatch(val)) {
                                  return widget.validateMessage ?? 'Error';
                                }
                                return null;
                              },
                          maxLines: widget.maxLines,
                          minLines: widget.minLines,
                          autofocus: widget.autoFocus,
                          enabled: widget.enabled,
                          style: widget.textStyle,
                          enableSuggestions: true,
                          decoration: widget.decoration?.copyWith(
                                labelText: widget.labelInHeader
                                    ? null
                                    : widget.isRequired
                                        ? '${widget.labelText}*'
                                        : widget.labelText,
                                helperText: widget.description,
                                labelStyle: TextStyle(
                                  fontSize: widget.labelSize,
                                  color: widget.labelColor,
                                ),
                              ) ??
                              InputDecoration(
                                helperText: widget.description,
                                labelText: widget.labelInHeader
                                    ? null
                                    : widget.isRequired
                                        ? '${widget.labelText}*'
                                        : widget.labelText,
                                labelStyle: TextStyle(
                                    fontSize: widget.labelSize,
                                    color: widget.labelColor),
                              ),
                        ),
                ),
                !widget.labelInHeader
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: toggleBtnsWidget(),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ));
  }

  Axis getDirection() {
    if (widget.toggleBtnsDirection != null) {
      return widget.toggleBtnsDirection!;
    } else {
      return (((widget.maxLines ?? 0) > 1) && (!widget.labelInHeader))
          ? Axis.vertical
          : Axis.horizontal;
    }
  }

  Widget toggleBtnsWidget() {
    return Column(
      children: [
        ToggleButtons(
          constraints: BoxConstraints(
            minHeight: 30,
            minWidth: 30,
          ),
          direction: getDirection(),
          // color: Colors.white,
          selectedColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          fillColor: Theme.of(context).primaryColor,
          children: myOptions
              .map((e) => Text(
                    e['label'].toString(),
                  ))
              .toList(),
          isSelected: myOptions.map((e) => (e['isSelected']) as bool).toList(),
          onPressed: (int index) {
            setState(() {
              if (myOptions[index]['isSelected'] == true) return;

              for (var option in myOptions) {
                option['isSelected'] = false;
              }

              myOptions[index]['isSelected'] =
                  !(myOptions[index]['isSelected'] as bool);
              _selectedLang = (myOptions[index]['label'] as String);

              textEdittingController.text =
                  _controllerData?[_selectedLang] ?? 'No Data';
              textEdittingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: textEdittingController.text.length));
            });
          },
        ),
        if (widget.isMarkdown)
          IconButton(
              icon:
                  isShown ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
              onPressed: () {
                isShown = !isShown;
                setState(() {});
              }),
      ],
    );
  }
}
