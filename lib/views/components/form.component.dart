part of alghwalbi_core;

class AppFormComponent extends StatefulWidget {
  final List<Property> properties;
  final Map<String, dynamic>? data;
  final void Function(Map<String, dynamic>)? onDataChanged;

  const AppFormComponent(this.properties,
      {super.key, this.data, this.onDataChanged});

  @override
  _AppFormComponentState createState() => _AppFormComponentState();
}

class _AppFormComponentState extends State<AppFormComponent> {
  Map<String, dynamic> data = {};
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    controllers = Map<String, TextEditingController>();
    data = widget.data ?? {};
    for (var prop in widget.properties) {
      if (prop.type == PropertyType.text) {
        controllers[prop.code] =
            TextEditingController(text: data[prop.code]?.toString() ?? '');
        controllers[prop.code]?.addListener(() {
          data[prop.code] = controllers[prop.code]?.text;
          widget.onDataChanged?.call(data);
        });
      }
    }
    super.initState();
  }

  onChange(Property prop) {
    if (prop.type == PropertyType.text) {
      data[prop.code] = controllers[prop.code]?.text;
    }
    widget.onDataChanged?.call(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: widget.properties.map((prop) => getControl(prop)).toList(),
      ),
    );
  }

  Widget getControl(Property prop) {
    switch (prop.type) {
      case PropertyType.text:
        return AppTextFormField(
            labelText: prop.label,
            obscureText: prop.isPassword,
            controller: controllers[prop.code],
            maxLines: prop.maxLines,
            validator: prop.validator,
            textInputAction: prop.textInputAction,
            //onEditingComplete: ()=>onChange(prop),
            keyboardType: prop.keyboardType);
      default:
        return Container();
    }
  }
}
