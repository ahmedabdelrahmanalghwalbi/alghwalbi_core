part of alghwalbi_core;

class AppTextFormField extends StatefulWidget {
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? regExp;
  final String? validateMessage;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final AutovalidateMode? autovalidateMode;

  /// must assign controller to user on text changed
  final void Function(String)? onTextChanged;
  final TextInputType? keyboardType;
  final String? labelText;
  final String? description;
  final bool isRequired;
  final Widget? icon;
  late bool obscureText;
  final bool autoFocus;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final bool isDarkBackgound;
  final TextDirection? textDirection;
  final TextStyle? textStyle;
  final bool enabled;
  final InputDecoration? decoration;
  final BoxDecoration? decorationIos;
  final List<TextInputFormatter>? textInputFormatter;

  AppTextFormField(
      {this.textInputAction,
      this.controller,
      this.regExp,
      this.decoration,
      this.autovalidateMode,
      this.decorationIos,
      this.validateMessage,
      this.isDarkBackgound = false,
      this.icon,
      this.textDirection,
      this.validator,
      this.keyboardType,
      this.labelText,
      this.description,
      this.isRequired = false,
      this.onEditingComplete,
      this.onTextChanged,
      this.focusNode,
      this.enabled = true,
      this.obscureText = false,
      this.autoFocus = false,
      this.onFieldSubmitted,
      this.maxLines = 1,
      this.minLines,
      this.textStyle,
      this.textInputFormatter,
      super.key}) {
    if (onTextChanged != null && controller != null) {
      controller!.addListener(() {
        onTextChanged!(controller!.text);
      });
    }
  }

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  TextStyle get defaultTextStyle => TextStyle(
      color:
          widget.isDarkBackgound ? Colors.white : ThemeService.mainTextColor);

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (widget.maxLines == null || widget.maxLines! > 1)
      result = getMultiRowText(context);
    else
      result = widget.icon == null
          ? getSingleRowText(context)
          : Stack(children: <Widget>[
              getSingleRowText(context),
              Container(
                  height: 60,
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Align(
                      child: widget.icon,
                      alignment: ConfigService.isRTL
                          ? Alignment.centerLeft
                          : Alignment.centerRight))
            ]);

    return widget.isDarkBackgound
        ? Theme(child: result, data: ThemeData.dark())
        : result;
  }

  Widget getSingleRowText(context) {
    return Tooltip(
        message: widget.description ?? '',
        child: !kIsWeb && Theme.of(context).platform == TargetPlatform.iOS
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    widget.labelText == null
                        ? const SizedBox()
                        : Text(
                            '${widget.labelText} ${widget.isRequired ? '*' : ''}',
                            style: TextStyle(
                                fontSize: 12.0,
                                color: widget.isDarkBackgound
                                    ? Colors.white
                                    : Colors.black38),
                          ),
                    CupertinoTextField(
                        controller: widget.controller,
                        textInputAction: widget.textInputAction,
                        keyboardType: widget.keyboardType,
                        //validator: validator,
                        inputFormatters: widget.textInputFormatter,
                        onEditingComplete: widget.onEditingComplete,
                        obscureText: widget.obscureText,
                        enabled: widget.enabled,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        placeholder: widget.labelText,
                        focusNode: widget.focusNode,
                        autofocus: widget.autoFocus,
                        onSubmitted: widget.onFieldSubmitted,
                        style: widget.textStyle ?? defaultTextStyle,
                        decoration: BoxDecoration()),
                    // Container(
                    //     height: 1.0,
                    //     color:
                    //         widget.isDarkBackgound ? Colors.white : Colors.black),
                    SizedBox(height: 15.0)
                  ])
            : TextFormField(
                inputFormatters: widget.textInputFormatter,
                autovalidateMode: widget.autovalidateMode,
                textDirection: widget.textDirection,
                enableInteractiveSelection: !widget.obscureText,
                textInputAction: widget.textInputAction,
                keyboardType: widget.keyboardType,
                controller: widget.controller,
                onEditingComplete: widget.onEditingComplete,
                focusNode: widget.focusNode,
                validator: widget.validator ??
                    (val) {
                      if (val == null || val.isEmpty)
                        return widget.isRequired
                            ? this.widget.validateMessage ?? 'Required'
                            : null;
                      if (this.widget.regExp == null) return null;
                      if (!RegExp(this.widget.regExp!).hasMatch(val)) {
                        return this.widget.validateMessage ?? 'Error';
                      }
                      return null;
                    },
                obscureText: widget.obscureText,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                autofocus: widget.autoFocus,
                enabled: widget.enabled,
                style: widget.textStyle ?? defaultTextStyle,
                onFieldSubmitted: widget.onFieldSubmitted,
                enableSuggestions: true,
                decoration: widget.decoration?.copyWith(
                        labelText: widget.isRequired
                            ? '${widget.labelText}*'
                            : widget.labelText,
                        helperText: widget.description) ??
                    InputDecoration(
                      helperText: widget.description,
                      labelText: widget.isRequired
                          ? '${widget.labelText}*'
                          : widget.labelText,
                      suffixIcon: widget.obscureText
                          ? IconButton(
                              onPressed: () {
                                widget.obscureText = !widget.obscureText;
                                setState(() {});
                              },
                              icon: Icon(!widget.obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off))
                          : const SizedBox(),
                      border: const UnderlineInputBorder(),
                    ),
              ));
  }

  Widget getMultiRowText(context) {
    return !kIsWeb && Theme.of(context).platform == TargetPlatform.iOS
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                widget.labelText == null
                    ? const SizedBox()
                    : Text(
                        '${widget.labelText} ${widget.isRequired ? '*' : ''}',
                        style: TextStyle(fontSize: 12.0)),
                const SizedBox(height: 5.9),
                Container(
                    height: widget.maxLines == null
                        ? null
                        : 25.0 * widget.maxLines!,
                    decoration: widget.decorationIos ??
                        const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.0)),
                                side: BorderSide(color: Colors.black38))),
                    child: Scrollbar(
                        child: SingleChildScrollView(
                            child: CupertinoTextField(
                                controller: widget.controller,
                                inputFormatters: widget.textInputFormatter,
                                onEditingComplete: widget.onEditingComplete,
                                focusNode: widget.focusNode,
                                textInputAction: widget.textInputAction,
                                keyboardType: TextInputType.multiline,
                                obscureText: widget.obscureText,
                                maxLines: widget.maxLines,
                                minLines: widget.minLines,
                                enabled: widget.enabled,
                                placeholder: widget.labelText,
                                style: widget.textStyle ?? defaultTextStyle,
                                decoration: const BoxDecoration()))))
              ])
        : TextFormField(
            autovalidateMode: widget.autovalidateMode,
            textDirection: widget.textDirection,
            enableInteractiveSelection: true,
            textInputAction: widget.textInputAction,
            keyboardType: TextInputType.multiline,
            controller: widget.controller,
            inputFormatters: widget.textInputFormatter,
            onEditingComplete: widget.onEditingComplete,
            validator: widget.validator ??
                (val) {
                  if (val == null || val.isEmpty)
                    return widget.isRequired
                        ? this.widget.validateMessage ?? 'Required'
                        : null;
                  if (this.widget.regExp == null) return null;
                  if (!RegExp(this.widget.regExp!).hasMatch(val)) {
                    return this.widget.validateMessage ?? 'Error';
                  }
                  return null;
                },
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            style: widget.textStyle ?? defaultTextStyle,
            decoration: widget.decoration?.copyWith(
                    labelText: widget.isRequired
                        ? '${widget.labelText}*'
                        : widget.labelText,
                    helperText: widget.description) ??
                InputDecoration(
                    helperText: widget.description,
                    labelText: widget.isRequired
                        ? '${widget.labelText}*'
                        : widget.labelText),
          );
  }
}
