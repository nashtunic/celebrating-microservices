import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:celebrate/AuthService.dart';
import 'services/news_feed_service.dart';
import 'models/news_feed_item.dart';
import 'login.dart';
import 'package:provider/provider.dart';
import 'providers/AuthProvider.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final NewsFeedService _feedService = NewsFeedService();
  final List<String> _categories = [
    'Lifestyle',
    'Music',
    'Sports',
    'Faith',
    'Personality'
  ];
  Map<String, List<NewsFeedItem>> _feedPosts = {};
  bool _isLoading = true;
  String _currentCategory = 'Lifestyle';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _categories.length, vsync: this);
    tabController.addListener(_handleTabChange);
    _checkAuthentication();
    _loadFeedPosts(_currentCategory);
  }

  @override
  void dispose() {
    tabController.dispose();
    _feedService.disconnect(); // Disconnect WebSocket when disposing
    super.dispose();
  }

  void _handleTabChange() {
    if (tabController.indexIsChanging) {
      setState(() {
        _currentCategory = _categories[tabController.index];
      });
      _loadFeedPosts(_currentCategory);
    }
  }

  Future<void> _checkAuthentication() async {
    final token = await AuthService.getToken();
    if (token == null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _loadFeedPosts(String category) async {
    if (_feedPosts[category] != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final posts =
          await _feedService.getNewsFeedItems(type: category.toLowerCase());
      setState(() {
        _feedPosts[category] = posts;
        _isLoading = false;
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

  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildFeedPost(NewsFeedItem post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Author Info
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: post.mediaUrls.isNotEmpty
                      ? NetworkImage(post.mediaUrls[0])
                      : const AssetImage('lib/images/feed.png')
                          as ImageProvider,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: GoogleFonts.andika(fontSize: 18),
                  ),
                  Text(
                    post.authorType,
                    style: GoogleFonts.andika(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: screenWidth * 0.92,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: GoogleFonts.andika(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.content,
                    style: GoogleFonts.andika(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Post Image
          if (post.mediaUrls.isNotEmpty)
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                      image: NetworkImage(post.mediaUrls[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (post.metadata?.containsKey('rating') ?? false)
                  Positioned(
                    left: screenWidth * 0.35,
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: List.generate(5, (index) {
                            final rating =
                                (post.metadata?['rating'] as num?)?.toInt() ??
                                    0;
                            return Icon(
                              Icons.star,
                              size: 20,
                              color:
                                  index < rating ? Colors.orange : Colors.grey,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          // Interaction Buttons
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.red : null,
                      ),
                      onPressed: () async {
                        try {
                          await _feedService.toggleLike(post.id);
                          setState(() {
                            final updatedPost = _feedPosts[_currentCategory]!
                                .firstWhere((p) => p.id == post.id);
                            final index = _feedPosts[_currentCategory]!
                                .indexOf(updatedPost);
                            _feedPosts[_currentCategory]![index] = NewsFeedItem(
                              id: post.id,
                              title: post.title,
                              content: post.content,
                              type: post.type,
                              authorId: post.authorId,
                              authorName: post.authorName,
                              authorType: post.authorType,
                              mediaUrls: post.mediaUrls,
                              metadata: post.metadata,
                              createdAt: post.createdAt,
                              likesCount: post.isLiked
                                  ? post.likesCount - 1
                                  : post.likesCount + 1,
                              commentsCount: post.commentsCount,
                              isLiked: !post.isLiked,
                            );
                          });
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error updating like: $e')),
                            );
                          }
                        }
                      },
                    ),
                    Text('${post.likesCount}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment),
                    const SizedBox(width: 4),
                    Text('${post.commentsCount}'),
                  ],
                ),
                Text(
                  '${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, size: 30),
                        onPressed: () {
                          // Handle search
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 30),
                        onPressed: _handleLogout,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              controller: tabController,
              indicatorColor: Theme.of(context).primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 9.0,
              isScrollable: true,
              labelColor: const Color(0xFF440206),
              unselectedLabelColor: const Color(0xFF440206),
              tabs: _categories
                  .map((category) => Tab(
                        child: Text(
                          category,
                          style: GoogleFonts.montserrat(fontSize: 15.0),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height -
                  200, // Adjust height to prevent overflow
              child: TabBarView(
                controller: tabController,
                children: _categories.map((category) {
                  if (_isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final posts = _feedPosts[category] ?? [];
                  if (posts.isEmpty) {
                    return Center(
                      child: Text(
                        'No posts available',
                        style: GoogleFonts.andika(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) =>
                        _buildFeedPost(posts[index]),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
