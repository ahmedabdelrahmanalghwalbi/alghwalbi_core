part of alghwalbi_core;

class TextFormWidget extends StatelessWidget {
  final String? label;
  final String? description;
  final Widget value;
  const TextFormWidget(
      {this.label, required this.value, this.description, super.key});
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: description ?? '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Text(label ?? '',
              style: TextStyle(color: ThemeService.textSubColor, fontSize: 11)),
          // Text(value, style: TextStyle(color: Colors.black, fontSize: 15)),
          value,
          const SizedBox(height: 10),
          Container(height: 1, color: ThemeService.textSubColor),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
