part of alghwalbi_core;

class LazyLoadMoreWidget extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  final Future<void> Function()? onLoadmore;

  final bool isLastPage;

  final Widget child;

  final Widget? noMoreWidget;

  final ScrollController? scrollController;

  const LazyLoadMoreWidget({
    super.key,
    required this.child,
    required this.isLastPage,
    required this.scrollController,
    this.onRefresh,
    this.onLoadmore,
    this.noMoreWidget,
  });

  @override
  RefreshLoadmoreState createState() => RefreshLoadmoreState();
}

class RefreshLoadmoreState extends State<LazyLoadMoreWidget> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  ScrollController? _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _scrollController!.addListener(() async {
      if (_scrollController!.position.pixels >=
          _scrollController!.position.maxScrollExtent) {
        if (_isLoading) {
          return;
        }

        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        if (!widget.isLastPage && widget.onLoadmore != null) {
          await widget.onLoadmore!();
        }

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWiget = Column(
      children: <Widget>[
        widget.child,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : widget.isLastPage
                      ? widget.noMoreWidget ??
                          Text(
                            'No more data',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).disabledColor,
                            ),
                          )
                      : Container(),
            ),
          ],
        )
      ],
    );

    if (widget.onRefresh == null) {
      return Scrollbar(child: mainWiget);
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        if (_isLoading) return;
        await widget.onRefresh!();
      },
      child: mainWiget,
    );
  }
}
