import 'package:flutter/material.dart';
import '../models/news_feed_item.dart';
import '../services/news_feed_service.dart';
import 'news_feed_item_widget.dart';

class CelebrityFeedWidget extends StatefulWidget {
  const CelebrityFeedWidget({Key? key}) : super(key: key);

  @override
  State<CelebrityFeedWidget> createState() => _CelebrityFeedWidgetState();
}

class _CelebrityFeedWidgetState extends State<CelebrityFeedWidget> {
  final NewsFeedService _newsFeedService = NewsFeedService();
  final List<NewsFeedItem> _feedItems = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadCelebrityFeed();
    _scrollController.addListener(_onScroll);
    _setupWebSocket();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _newsFeedService.disconnect();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadCelebrityFeed();
    }
  }

  Future<void> _loadCelebrityFeed() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Add celebrity-specific parameter to the API call
      final items = await _newsFeedService.getNewsFeedItems(
        page: _currentPage,
        authorType: 'celebrity',
      );

      setState(() {
        _feedItems.addAll(items);
        _isLoading = false;
        _hasMore = items.isNotEmpty;
        if (_hasMore) _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading celebrity feed: $e')),
        );
      }
    }
  }

  void _setupWebSocket() {
    _newsFeedService.connectToWebSocket((item) {
      // Only add items from celebrity accounts
      if (mounted && item.metadata?['authorType'] == 'celebrity') {
        setState(() {
          _feedItems.insert(0, item);
        });
      }
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _feedItems.clear();
      _currentPage = 0;
      _hasMore = true;
      _isLoading = true;
    });
    await _loadCelebrityFeed();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _feedItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: _feedItems.isEmpty
          ? const Center(
              child: Text('No celebrity posts yet'),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _feedItems.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _feedItems.length) {
                  return _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox();
                }

                final item = _feedItems[index];
                return Column(
                  children: [
                    NewsFeedItemWidget(
                      item: item,
                      onRefresh: _refresh,
                      onRatingTap: () {
                        // Show ratings modal
                        // This will be handled by the parent widget
                      },
                    ),
                    if (index < _feedItems.length - 1) const Divider(height: 1),
                  ],
                );
              },
            ),
    );
  }
}
