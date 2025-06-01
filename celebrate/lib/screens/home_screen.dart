import 'package:flutter/material.dart';
import '../models/news_feed_item.dart';
import '../services/news_feed_service.dart';
import '../widgets/news_feed_item_widget.dart';
import '../widgets/rating_input_widget.dart';
import '../widgets/ratings_list_widget.dart';
import '../widgets/celebrity_feed_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NewsFeedService _newsFeedService = NewsFeedService();
  final List<NewsFeedItem> _feedItems = [];
  bool _isLoading = true;
  bool _hasMore = true;
  int _currentPage = 0;
  String? _selectedType;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFeed();
    _setupWebSocket();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _newsFeedService.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadFeed();
    }
  }

  Future<void> _loadFeed() async {
    if (!_hasMore || _isLoading) return;

    try {
      final items = await _newsFeedService.getNewsFeedItems(
        page: _currentPage,
        type: _selectedType,
        authorType: 'regular', // Only get regular user posts in the main feed
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
          SnackBar(content: Text('Error loading feed: $e')),
        );
      }
    }
  }

  void _setupWebSocket() {
    _newsFeedService.connectToWebSocket((item) {
      if (mounted && item.metadata?['authorType'] == 'regular') {
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
    await _loadFeed();
  }

  void _showRatings(NewsFeedItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            AppBar(
              title: const Text('Ratings & Reviews'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: RatingsListWidget(
                targetId: item.id,
                targetType: 'post',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RatingInputWidget(
                targetId: item.id,
                targetType: 'post',
                onRatingSubmitted: () {
                  // Refresh the ratings list
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All'),
                selected: _selectedType == null,
                onTap: () {
                  setState(() {
                    _selectedType = null;
                  });
                  Navigator.pop(context);
                  _refresh();
                },
              ),
              ListTile(
                title: const Text('Celebrations'),
                selected: _selectedType == 'celebration',
                onTap: () {
                  setState(() {
                    _selectedType = 'celebration';
                  });
                  Navigator.pop(context);
                  _refresh();
                },
              ),
              ListTile(
                title: const Text('Achievements'),
                selected: _selectedType == 'achievement',
                onTap: () {
                  setState(() {
                    _selectedType = 'achievement';
                  });
                  Navigator.pop(context);
                  _refresh();
                },
              ),
              ListTile(
                title: const Text('Announcements'),
                selected: _selectedType == 'announcement',
                onTap: () {
                  setState(() {
                    _selectedType = 'announcement';
                  });
                  Navigator.pop(context);
                  _refresh();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainFeed() {
    if (_isLoading && _feedItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _feedItems.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _feedItems.length) {
            if (_hasMore) {
              _loadFeed();
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return null;
          }

          final item = _feedItems[index];
          return Column(
            children: [
              NewsFeedItemWidget(
                item: item,
                onRefresh: _refresh,
                onRatingTap: () => _showRatings(item),
              ),
              if (index < _feedItems.length - 1) const Divider(height: 1),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Celebrate'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Celebrity Feed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMainFeed(),
          const CelebrityFeedWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create post screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
