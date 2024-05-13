part of alghwalbi_core;

class ImageService {
  Future<XFile?> getImage({
    ImageSource source = ImageSource.gallery,
    double maxHeight = 200,
    double maxWidth = 200,
    int? imageQuality,
  }) async {
    //if (kIsWeb) return await _setImageWeb();

    var image = await ImagePicker().pickImage(
        source: source,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality);
    return image;
  }

  // Future<FileInfo?> _setImageWeb() async {
  //   return null;
  //   // final completer = Completer<List<String>>();
  //   // InputElement uploadInput = FileUploadInputElement();
  //   // uploadInput.multiple = true;
  //   // uploadInput.accept = 'image/*';
  //   // uploadInput.click();
  //   // //* onChange doesn't work on mobile safari
  //   // uploadInput.addEventListener('change', (e) async {
  //   //   // read file content as dataURL
  //   //   final files = uploadInput.files;
  //   //   Iterable<Future<String>> resultsFutures = files.map((file) {
  //   //     final reader = FileReader();
  //   //     reader.readAsDataUrl(file);
  //   //     reader.onError.listen((error) => completer.completeError(error));
  //   //     return reader.onLoad.first.then((_) => reader.result as String);
  //   //   });

  //   //   final results = await Future.wait(resultsFutures);
  //   //   completer.complete(results);
  //   // });
  //   // //* need to append on mobile safari
  //   // document.body.append(uploadInput);
  //   // final List<String> images = await completer.future;
  //   // print('======================== Web images');
  //   // var image = base64Decode(images.first.replaceFirst('data:image/jpeg;base64,', ''));
  //   // print( image.length);
  //   // uploadInput.remove();
  //   // return FileInfo(name:'file.jpg',data: image);
  // }

  // static String imageUrl(id) {
  //   return '${ApiService.apiURL}Attachment/image/$id/${ConfigService.token}';
  // }

  static Widget image(id, {double radius = 30}) {
    //return Image.network('${ApiService.apiURL}Attachment/image/$id/${ConfigService.token}');
    //return Image.network('${ApiService.apiURL}Attachment/image/$id',headers: {'Authorization':'Bearer ${ConfigService.token}'},height:height);

    if (id == null ||
        id.length == 0 ||
        id == 'null' ||
        ApiService.apiURL == null ||
        ApiService.apiURL!.isEmpty ||
        ApiService.apiURL!.contains('null')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: ThemeService.backgroundSecondColor,
        child: Icon(Icons.error, color: ThemeService.backgroundColor),
      );
    }

    // if (kIsWeb) {
    //   return CircleAvatar(
    //       child: Transform.scale(
    //           scale: 0.6,
    //           child: Image.network('${ApiService.apiURL}Attachment/image/$id',
    //               headers: {'Authorization': 'Bearer ${ConfigService.token}'})),
    //       radius: radius,
    //       backgroundColor: ThemeService.backgroundSecondColor);
    // }

    return CachedNetworkImage(
      imageUrl: id.startsWith('http')
          ? id
          : '${ApiService.apiURL}Attachment/image/$id',
      httpHeaders: {'Authorization': 'Bearer ${ConfigService.token}'},
      imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          radius: radius,
          backgroundColor: ThemeService.backgroundSecondColor),
      // Container(
      //   height: height,
      //   width: width,
      //   decoration: BoxDecoration(
      //     //borderRadius: BorderRadius.circular(10),//.all(Radius.circular(10)),
      //     //borderRadius: BorderRadius.all(Radius.circular(35)),
      //     shape: BoxShape.circle,
      //     image: DecorationImage(
      //       image: imageProvider,
      //       fit: BoxFit.scaleDown,
      //       //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
      //     ),
      //   ),
      // ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: ThemeService.backgroundSecondColor,
        child: Transform.scale(
            scale: 0.6, child: const CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
          radius: radius,
          backgroundColor: ThemeService.backgroundSecondColor,
          child: Icon(Icons.error, color: ThemeService.backgroundColor)),
    );
  }

  static ImageProvider? imageProvider(id, {double? height, double? width}) {
    if (id == null ||
        id.length == 0 ||
        id == 'null' ||
        ApiService.apiURL == null ||
        ApiService.apiURL!.isEmpty ||
        ApiService.apiURL!.contains('null')) return null;
    return kIsWeb
        ? Image.network(
            id.toString().startsWith('http')
                ? id
                : '${ApiService.apiURL}Attachment/image/$id',
            headers: {'Authorization': 'Bearer ${ConfigService.token}'}).image
        : CachedNetworkImageProvider(
            id.toString().startsWith('http')
                ? id ?? ''
                : '${ApiService.apiURL}Attachment/image/$id',
            headers: {'Authorization': 'Bearer ${ConfigService.token}'});
  }

  static Image? getImageEx(id, {double? height, double? width}) {
    if (id == null ||
        id.length == 0 ||
        id == 'null' ||
        ApiService.apiURL == null ||
        ApiService.apiURL!.isEmpty ||
        ApiService.apiURL!.contains('null')) return null;
    return Image.network(
        id.startsWith('http') ? id : '${ApiService.apiURL}Attachment/image/$id',
        headers: {'Authorization': 'Bearer ${ConfigService.token}'});
  }

  static Future<Uint8List?> getImageBytes(id) async {
    if (id == null ||
        id.length == 0 ||
        id == 'null' ||
        ApiService.apiURL == null ||
        ApiService.apiURL!.isEmpty ||
        ApiService.apiURL!.contains('null')) return null;

    var val = await http.get(
        Uri.parse(id.startsWith('http')
            ? id
            : '${ApiService.apiURL}Attachment/image/$id'),
        headers: {
          'Authorization': 'Bearer ${ConfigService.token}',
        });
    return val.bodyBytes;
  }
}

class FileInfo {
  String name;
  List<int> data;
  FileInfo({required this.name, required this.data});
}
