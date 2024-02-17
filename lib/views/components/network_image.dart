part of alghwalbi_core;

class AppNetworkImage extends StatelessWidget {
  final String url;
  const AppNetworkImage(this.url, {super.key});
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
