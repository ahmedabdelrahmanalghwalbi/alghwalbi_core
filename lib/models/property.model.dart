part of alghwalbi_core;

class Property extends BaseModel {
  /// property name
  String label;

  /// property code
  String code;

  /// property type
  PropertyType type;

  /// validator function
  String Function(String?) validator;

  /// in case of test
  TextInputType keyboardType;

  /// is for password
  bool isPassword;

  /// maxlines
  int maxLines;

  /// input action
  TextInputAction textInputAction;

  /// in case of dropdown
  List<BaseModel>? options;

  /// property base model
  Property(this.code, this.type,
      {this.label = '',
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.maxLines = 1,
      this.textInputAction = TextInputAction.done,
      this.options});

  @override
  String get displayName => label;

  @override
  String get idValue => code;
}
