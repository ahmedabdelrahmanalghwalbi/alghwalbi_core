part of alghwalbi_core;

class SearchBox extends StatefulWidget {
  final TextEditingController? searchTextController;
  final void Function(String)? onChange;
  final void Function(String)? onSubmit;
  final String placeholder;
  final FocusNode? focusNode;
  const SearchBox(
      {this.searchTextController,
      required this.placeholder,
      this.onChange,
      this.focusNode,
      this.onSubmit,
      super.key});
  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  FocusNode? focusNode;
  TextEditingController? searchTextController;
  bool hasFocus = false;
  @override
  void initState() {
    searchTextController =
        widget.searchTextController ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    focusNode?.addListener(() {
      hasFocus = focusNode?.hasFocus ?? false;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  void onChange(val) {
    if (widget.onChange != null) {
      widget.onChange?.call(val.toString().toLowerCase());
    }
  }

  void onSubmit(val) {
    if (widget.onSubmit != null) widget.onSubmit?.call(val);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 45,
              margin: EdgeInsets.only(
                  left: 10.0,
                  top:
                      Theme.of(context).platform == TargetPlatform.iOS ? 2 : 7),
              // padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeService.mainColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoTextField(
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: ThemeService.mainColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                          controller: searchTextController,
                          onChanged: onChange,
                          onSubmitted: onSubmit,
                          focusNode: focusNode,
                          placeholder: widget.placeholder,
                          prefix: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, top: 10, right: 5),
                            child: Icon(
                              Icons.search,
                              color: ThemeService.mainColor,
                              size: 35.0,
                            ),
                          ),
                          decoration: const BoxDecoration(
                              //contentPadding: EdgeInsets.only(top:20.0),
                              //hintStyle: TextStyle(fontWeight: FontWeight.w500,color: ThemeService.Black26Gray,fontSize: 16.0,letterSpacing: 1.0
                              ),
                          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                          //border: InputBorder.none
                          //),
                        )
                      : TextField(
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          controller: searchTextController,
                          onChanged: onChange,
                          onSubmitted: onSubmit,
                          focusNode: focusNode,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(Icons.search,
                                    size: 30, color: ThemeService.mainColor),
                              ),
                              hintText: widget.placeholder,
                              hintStyle: TextStyle(
                                  color:
                                      ThemeService.mainColor.withOpacity(0.3)),
                              border: InputBorder.none),
                        ),
                ),
                isKeyboardIsOpen
                    ? IconButton(
                        icon: const Icon(Icons.cancel),
                        tooltip: 'Cancel Search',
                        onPressed: () {
                          focusNode?.unfocus();
                          searchTextController?.text = '';
                          onChange('');
                        })
                    : Container(),
                const SizedBox(width: 10)
              ],
            )
          ],
        ));
  }

  bool get isKeyboardIsOpen {
    return hasFocus ||
        (searchTextController?.text.isNotEmpty ??
            false); //MediaQuery.of(context).viewInsets.bottom != 0;
  }
}
