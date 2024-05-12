// part of alghwalbi_core;

// class MultiLangHtmlEditor extends StatefulWidget {
//   final Map<String, dynamic> data;
//   final void Function(Map<String, dynamic>) onChangedEx;
//   final int? maxLines;
//   final double? labelSize;
//   final Axis? toggleBtnsDirection;
//   final int? minLines;
//   final Color? labelColor;
//   final String? labelText;
//   final String? description;
//   final bool isRequired;
//   final bool labelInHeader;

//   const MultiLangHtmlEditor(
//       {required this.data,
//       required this.onChangedEx,
//       this.toggleBtnsDirection,
//       this.isRequired = false,
//       this.maxLines,
//       this.minLines,
//       this.labelInHeader = false,
//       this.labelSize,
//       this.labelColor = Colors.grey,
//       this.description,
//       this.labelText,
//       Key? key})
//       : super(key: key);

//   @override
//   State<MultiLangHtmlEditor> createState() => _MultiLangHtmlEditorState();
// }

// class _MultiLangHtmlEditorState extends State<MultiLangHtmlEditor> {
//   List<Map<String, dynamic>> myOptions = [
//     {"label": 'en', 'isSelected': !ConfigService.isRTL},
//     {"label": 'ar', 'isSelected': ConfigService.isRTL},
//   ];

//   String? _selectedLang;

//   Map<String, dynamic>? _controllerData;

//   // var textEdittingController = TextEditingController();
//   HtmlEditorController controller = HtmlEditorController();

//   bool isShown = false;

//   @override
//   void initState() {
//     init();

//     super.initState();
//   }

//   init() async {
//     await Future.delayed(
//       const Duration(milliseconds: 1500),
//       () {
//         for (var option in myOptions) {
//           _controllerData ??= {};
//           _controllerData?[option['label'] ?? ''] = '';
//           _controllerData?[option['label']] = widget.data[option['label']];
//         }
//         print(_controllerData);
//         _selectedLang = myOptions
//             .where((element) => element['isSelected'] == true)
//             .first['label'];
//       },
//     );
//     setState(() {});
//   }

//   String formateHtml(String htmlCode) {
//     if (htmlCode.startsWith('<p><br></p><p></p>')) {
//       htmlCode =
//           htmlCode.substring('<p><br></p><p></p>'.length, htmlCode.length);
//       formateHtml(htmlCode);
//     } else if (htmlCode.startsWith('<p><br></p>')) {
//       htmlCode = htmlCode.substring('<p><br></p>'.length, htmlCode.length);
//       formateHtml(htmlCode);
//     }
//     return htmlCode;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//         message: widget.description ?? '',
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: Colors.grey.shade200),
//           child: Padding(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   !widget.labelInHeader
//                       ? const SizedBox()
//                       : Row(
//                           children: [
//                             Text(
//                                 '${widget.labelText} ${widget.isRequired ? '*' : ''}',
//                                 style: TextStyle(fontSize: widget.labelSize)),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             toggleBtnsWidget(),
//                           ],
//                         ),
//                   Row(
//                     children: <Widget>[
//                       Expanded(
//                         child:
//                             Html(data: _controllerData?[_selectedLang!] ?? ''),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.edit),
//                         onPressed: () async {
//                           Future.delayed(const Duration(milliseconds: 1500),
//                               () {
//                             if (_selectedLang != null &&
//                                 _controllerData?[_selectedLang] != null) {
//                               controller.insertHtml(
//                                   formateHtml(_controllerData?[_selectedLang]));
//                             }
//                           });
//                           await AppNavigator.showAppDialogEx(
//                               context,
//                               () => Scaffold(
//                                     body: HtmlEditor(
//                                       controller: controller,
//                                       htmlToolbarOptions:
//                                           const HtmlToolbarOptions(
//                                               toolbarType:
//                                                   ToolbarType.nativeGrid),
//                                       htmlEditorOptions: HtmlEditorOptions(
//                                         hint: widget.labelText,
//                                       ),
//                                       callbacks: Callbacks(
//                                         onChangeContent: (p0) {
//                                           _controllerData?[_selectedLang!] =
//                                               formateHtml(p0 ?? '');
//                                           widget.onChangedEx
//                                               .call(_controllerData ?? {});
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                               size: DialogBoxSizes.large);
//                           setState(() {});
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//         ));
//   }

//   Axis getDirection() {
//     if (widget.toggleBtnsDirection != null) {
//       return widget.toggleBtnsDirection!;
//     } else {
//       return (((widget.maxLines ?? 0) > 1) && (!widget.labelInHeader))
//           ? Axis.vertical
//           : Axis.horizontal;
//     }
//   }

//   Widget toggleBtnsWidget() {
//     return Column(
//       children: [
//         ToggleButtons(
//           constraints: const BoxConstraints(
//             minHeight: 30,
//             minWidth: 30,
//           ),
//           direction: getDirection(),
//           // color: Colors.white,
//           selectedColor: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           fillColor: Theme.of(context).primaryColor,
//           children: myOptions
//               .map((e) => Text(
//                     e['label'].toString(),
//                   ))
//               .toList(),
//           isSelected: myOptions.map((e) => (e['isSelected']) as bool).toList(),
//           onPressed: (int index) {
//             setState(() {
//               if (myOptions[index]['isSelected'] == true) return;

//               for (var option in myOptions) {
//                 option['isSelected'] = false;
//               }

//               myOptions[index]['isSelected'] =
//                   !(myOptions[index]['isSelected'] as bool);
//               _selectedLang = (myOptions[index]['label'] as String);
//             });
//           },
//         ),
//       ],
//     );
//   }
// }
